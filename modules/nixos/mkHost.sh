#!/bin/sh
set -euo pipefail

echo -n "Enter hostname: "
read HOST
[ -z "$HOST" ] && { echo "Error: Hostname cannot be empty"; exit 1; }

BASE_CONFIG_PATH="/var/lib/nixconf/hosts/$HOST"
mkdir -p "$BASE_CONFIG_PATH/secrets"

echo -n "Enter time zone [Europe/Warsaw]: "
read TIMEZONE
TIMEZONE=${TIMEZONE:-Europe/Warsaw}

echo -n "Enter locale [en_US.UTF-8]: "
read LOCALE
LOCALE=${LOCALE:-en_US.UTF-8}

echo -n "Use legacy bootloader? [Y/n]: "
read USE_LEGACY
USE_LEGACY=${USE_LEGACY:-Y}

LEGACY_SETTING="false"
if echo "$USE_LEGACY" | grep -iqE '^y(es)?$|^$'; then
  LEGACY_SETTING="true"
  BOOTLOADER="grub"
else
  echo -n "Choose bootloader [systemd-boot/grub] (default: systemd-boot): "
  read BOOTLOADER
  BOOTLOADER=${BOOTLOADER:-systemd-boot}
  if [ "$BOOTLOADER" != "systemd-boot" ] && [ "$BOOTLOADER" != "grub" ]; then
    echo "Error: Invalid bootloader choice"
    exit 1
  fi
fi

cat <<EOF > "$BASE_CONFIG_PATH/hardware-configuration.nix"
{ ... }: { }
EOF

cat <<EOF > "$BASE_CONFIG_PATH/default.nix"
{ ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  system = {
    bootloader = {
      variant = "$BOOTLOADER";
      legacy = $LEGACY_SETTING;
    };
    fileSystem = "btrfs";
  };

  time.timeZone = "$TIMEZONE";
  i18n.defaultLocale = "$LOCALE";
}
EOF

TMP_KEY=$(mktemp -u /tmp/ssh_key_XXXXXXXX)
ssh-keygen -t ed25519 -N "" -f "$TMP_KEY" <<< y >/dev/null
SSH_KEY=$(cat "$TMP_KEY")

AGE_PRIVATE_KEY=$(echo "$SSH_KEY" | nix run nixpkgs#ssh-to-age -- -private-key -i -)
[ -z "$AGE_PRIVATE_KEY" ] && { echo "Error: Failed to convert to Age private key"; exit 1; }

AGE_PUBLIC_KEY=$(echo "$AGE_PRIVATE_KEY" | nix shell nixpkgs#age -c age-keygen -y -)
[ -z "$AGE_PUBLIC_KEY" ] && { echo "Error: Failed to generate Age public key"; exit 1; }

cat <<EOF > "$BASE_CONFIG_PATH/.sops.yaml"
keys:
  - &root $AGE_PUBLIC_KEY
creation_rules:
  - path_regex: secrets/secrets.yaml$
    key_groups:
      - age:
        - *root
EOF

touch "$BASE_CONFIG_PATH/secrets/secrets.yaml"

echo "Host $HOST initialized successfully!"
echo "Bootloader: $BOOTLOADER (legacy: $LEGACY_SETTING)"
echo "Private SSH key: $TMP_KEY"
echo "Public SSH key: $TMP_KEY.pub"

exit 0
