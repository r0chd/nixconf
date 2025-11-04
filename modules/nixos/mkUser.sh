#!/bin/sh

echo -n "Enter hostname: "
read HOST

if [ -z "$HOST" ]; then
  echo "Error: Could not determine hostname"
  exit 1
fi

BASE_CONFIG_PATH="/var/lib/nixconf/hosts/$HOST"
if [ ! -d "$BASE_CONFIG_PATH" ]; then
  echo "Error: Host configuration directory doesn't exist: $BASE_CONFIG_PATH"
  exit 1
fi

echo -n "Enter username: "
read USERNAME

if [ -z "$USERNAME" ]; then
  echo "Error: Username cannot be empty"
  exit 1
fi

if ! echo "$USERNAME" | grep -q '^[a-z_][a-z0-9_-]*$'; then
  echo "Error: Invalid username format. Use lowercase letters, numbers, underscore, and hyphen."
  exit 1
fi

CONFIG_PATH="${BASE_CONFIG_PATH}/users/$USERNAME"

if [ -d "$CONFIG_PATH" ]; then
  echo "User $USERNAME already exists"
  exit 1
fi

echo -n "Enter password: "
read -s PASSWORD
echo
echo -n "Confirm password: "
read -s CONFIRM_PASSWORD
echo

if [ -z "$PASSWORD" ]; then
  echo "Error: Password cannot be empty"
  exit 1
fi

if [ "$PASSWORD" != "$CONFIRM_PASSWORD" ]; then
  echo "Error: Passwords do not match"
  exit 1
fi

if [ ${#PASSWORD} -lt 8 ]; then
  echo "Warning: Password is less than 8 characters long"
  echo -n "Continue anyway? (y/N): "
  read CONTINUE
  if [ "$CONTINUE" != "y" ] && [ "$CONTINUE" != "Y" ]; then
    echo "User creation cancelled"
    exit 1
  fi
fi

PASSWORD=$(mkpasswd "$PASSWORD")

echo -n "Enter email: "
read EMAIL

if [ -z "$EMAIL" ]; then
  echo "Error: Email cannot be empty"
  exit 1
fi

echo -n "Enter preferred editor (e.g. hx, nvim, vim): "
read EDITOR

if [ -z "$EDITOR" ]; then
  echo "Error: Editor cannot be empty"
  exit 1
fi

mkdir -p "$CONFIG_PATH"/secrets
if [ $? -ne 0 ]; then
  echo "Error: Failed to create configuration directories"
  exit 1
fi

cat <<EOF > "$CONFIG_PATH/default.nix"
{ ... }:
{
  programs = {
    editor = "$EDITOR";
    vcs.email = "$EMAIL";
  };
}
EOF

echo "Generating SSH and Age keys..."

SSH_KEY=$(ssh-keygen -t ed25519 -N "" -f /tmp/temp_ed25519_key <<< y >/dev/null 2>&1 && cat /tmp/temp_ed25519_key && rm /tmp/temp_ed25519_key)
if [ $? -ne 0 ] || [ -z "$SSH_KEY" ]; then
  echo "Error: Failed to generate SSH key"
  exit 1
fi

AGE_PRIVATE_KEY=$(echo "$SSH_KEY" | nix run nixpkgs#ssh-to-age -- -private-key -i -)
if [ $? -ne 0 ] || [ -z "$AGE_PRIVATE_KEY" ]; then
  echo "Error: Failed to convert SSH key to Age private key"
  exit 1
fi

AGE_PUBLIC_KEY=$(echo "$AGE_PRIVATE_KEY" | nix shell nixpkgs#age -c age-keygen -y -)
if [ $? -ne 0 ] || [ -z "$AGE_PUBLIC_KEY" ]; then
  echo "Error: Failed to generate Age public key"
  exit 1
fi

ROOT_AGE_PUBLIC_KEY=$(sed -n 's/.*&root \(age1[a-z0-9]*\).*/\1/p' "$BASE_CONFIG_PATH/.sops.yaml")
if [ $? -ne 0 ] || [ -z "$ROOT_AGE_PUBLIC_KEY" ]; then
  echo "Error: Failed to read root's Age public key"
  exit 1
fi

cat <<EOF > "$CONFIG_PATH/.sops.yaml"
keys:
  - &$USERNAME $AGE_PUBLIC_KEY
  - &root $ROOT_AGE_PUBLIC_KEY
creation_rules:
  - path_regex: secrets/secrets.yaml\$
    key_groups:
      - age:
        - *$USERNAME
        - *root
EOF

cd "$CONFIG_PATH"
cat <<EOF | sops encrypt --filename-override secrets/secrets.yaml > "$CONFIG_PATH/secrets/secrets.yaml"
$USERNAME:
  password: $PASSWORD
  ssh: |
$(echo "$SSH_KEY" | sed 's/^/    /')
EOF

if [ $? -ne 0 ]; then
  echo "Error: Failed to encrypt secrets"
  exit 1
fi

echo "User $USERNAME created successfully!"
echo "Now run \"nh os switch\""

exit 0
