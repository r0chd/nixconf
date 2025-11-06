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
    secrets = systemUsers
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
      sops-generate-root-key = {
        description = "Generate SOPS age keys from SSH keys";

        after = [ "local-fs.target" ];
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
          RequiresMountsFor = lib.optional config.services.impermanence.enable "/persist";
        };

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          User = "root";
        };

        script = ''
          mkdir -p "$(dirname "${root}/.config/sops/age/keys.txt")"
          ${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i "${root}/.ssh/id_ed25519" > "${root}/.config/sops/age/keys.txt"
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
        mkdir -p "$(dirname "$HOME/.config/sops/age/keys.txt")"
        ${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i "$HOME/.ssh/id_ed25519" > "$HOME/.config/sops/age/keys.txt"
      '';
    };

  };
}
