{
  inputs,
  pkgs,
  config,
  lib,
  systemUsers,
  ...
}:
let
  root = if config.services.impermanence.enable then "/persist/system/root" else "/root";
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  environment.persist.directories = [
    {
      directory = "/root/.config/sops";
      user = "root";
      group = "root";
      mode = "u=rwx, g=, o=";
    }
  ];

  sops = {
    secrets =
      systemUsers
      |> builtins.attrNames
      |> builtins.concatMap (user: [
        {
          name = "${user}/password";
          value = {
            neededForUsers = true;
            sopsFile = ../../../../hosts/${config.networking.hostName}/users/${user}/secrets/secrets.yaml;
          };
        }
        {
          name = "${user}/ssh";
          value = {
            owner = user;
            path = "/home/${user}/.ssh/id_ed25519";
            sopsFile = ../../../../hosts/${config.networking.hostName}/users/${user}/secrets/secrets.yaml;
          };
        }
      ])
      |> lib.listToAttrs;

    defaultSopsFile = ../../../../hosts/${config.networking.hostName}/secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age = {
      sshKeyPaths = [ "${root}/.ssh/id_ed25519" ];
      keyFile = "${root}/.config/sops/age/keys.txt";
    };
  };

  environment = {
    systemPackages = [ pkgs.sops ];
    shellAliases.opensops = "SOPS_AGE_KEY_FILE=\"${config.sops.age.keyFile}\" sops /var/lib/nixconf/hosts/${config.networking.hostName}/secrets/secrets.yaml";
  };

  systemd = {
    services = {
      userborn = lib.mkIf config.services.userborn.enable {
        wants = [
          "sops-install-secrets-for-users.service"
          "sops-generate-user-keys.service"
        ];
        after = [
          "sops-install-secrets-for-users.service"
          "sops-generate-user-keys.service"
        ];
      };

      sops-generate-root-key = {
        description = "Generate SOPS age keys from SSH keys";

        after = [
          "systemd-remount-fs.service"
        ];
        wants = [
          "local-fs.target"
        ];
        before = [
          "sops-install-secrets.service"
          "sops-install-secrets-for-users.service"
        ];
        requiredBy = [
          "sops-install-secrets.service"
          "sops-install-secrets-for-users.service"
        ];
        unitConfig = {
          DefaultDependencies = "no";
        };

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          User = "root";
        };

        script = ''
          set -euo pipefail

          KEY_FILE="${root}/.config/sops/age/keys.txt"
          SSH_KEY="${root}/.ssh/id_ed25519"

          # Create directory if it doesn't exist
          mkdir -p "$(dirname "$KEY_FILE")"

          # Check if key file already exists (e.g., from impermanence)
          if [ -f "$KEY_FILE" ]; then
            echo "SOPS age key file already exists, skipping generation"
            exit 0
          fi

          # Wait for SSH key to exist (with timeout)
          if [ ! -f "$SSH_KEY" ]; then
            echo "Waiting for SSH key to be available..."
            for _ in {1..30}; do
              if [ -f "$SSH_KEY" ]; then
                break
              fi
              sleep 1
            done
            
            if [ ! -f "$SSH_KEY" ]; then
              echo "ERROR: SSH key not found at $SSH_KEY after 30 seconds"
              exit 1
            fi
          fi

          # Generate age key from SSH key
          echo "Generating SOPS age key from SSH key..."
          ${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i "$SSH_KEY" > "$KEY_FILE"

          # Verify the key file was created successfully
          if [ ! -f "$KEY_FILE" ] || [ ! -s "$KEY_FILE" ]; then
            echo "ERROR: Failed to generate SOPS age key file"
            exit 1
          fi

          echo "SOPS age key generated successfully"
        '';
      };
    };

    user.services.sops-generate-user-keys = {
      description = "Generate SOPS age keys from SSH keys";

      before = [ "sops-nix.service" ];
      wantedBy = [ "default.target" ];

      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };

      script = ''
        set -euo pipefail

        KEY_FILE="$HOME/.config/sops/age/keys.txt"
        SSH_KEY="$HOME/.ssh/id_ed25519"

        # Create directory if it doesn't exist
        mkdir -p "$(dirname "$KEY_FILE")"

        # Check if key file already exists (e.g., from impermanence)
        if [ -f "$KEY_FILE" ]; then
          echo "SOPS age key file already exists, skipping generation"
          exit 0
        fi

        # Wait for SSH key to exist (with timeout)
        if [ ! -f "$SSH_KEY" ]; then
          echo "Waiting for SSH key to be available..."
          for _ in {1..30}; do
            if [ -f "$SSH_KEY" ]; then
              break
            fi
            sleep 1
          done
          
          if [ ! -f "$SSH_KEY" ]; then
            echo "ERROR: SSH key not found at $SSH_KEY after 30 seconds"
            exit 1
          fi
        fi

        # Generate age key from SSH key
        echo "Generating SOPS age key from SSH key..."
        ${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i "$SSH_KEY" > "$KEY_FILE"

        # Verify the key file was created successfully
        if [ ! -f "$KEY_FILE" ] || [ ! -s "$KEY_FILE" ]; then
          echo "ERROR: Failed to generate SOPS age key file"
          exit 1
        fi

        echo "SOPS age key generated successfully"
      '';
    };

  };
}
