{ inputs, pkgs, std, config, lib, username, ... }: {
  imports = [ inputs.sops-nix.nixosModules.sops ];

  options.sops = {
    enable = lib.mkEnableOption "sops";
    managePassword = lib.mkEnableOption "manage passwords with sops";
  };

  config = lib.mkIf config.sops.enable {
    sops = {
      defaultSopsFile = "${std.dirs.host}/secrets/secrets.yaml";
      secrets.password.neededForUsers =
        lib.mkIf config.sops.managePassword true;
    };

    home-manager.users."${username}" = {
      impermanence.persist.directories = [ ".config/sops/age" ];
      imports = [ inputs.sops-nix.homeManagerModules.sops ];
      sops = {
        defaultSopsFile = "${std.dirs.host}/secrets/secrets.yaml";
        defaultSopsFormat = "yaml";
        age = {
          sshKeyPaths = [ "${std.dirs.home-persist}/.ssh/id_ed25519" ];
          keyFile = "${std.dirs.home-persist}/.config/sops/age/keys.txt";
        };
      };
      home = {
        packages = with pkgs; [ sops ];
        shellAliases.opensops = "sops ${std.dirs.host}/secrets/secrets.yaml";
        activation.sopsGenerateKey = let
          escapedKeyFile = lib.escapeShellArg
            config.home-manager.users.${username}.sops.age.keyFile;
          sshKeyPath = builtins.elemAt
            config.home-manager.users.${username}.sops.age.sshKeyPaths 0;
        in ''
          mkdir -p $(dirname ${escapedKeyFile})
          ${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i ${sshKeyPath} > ${escapedKeyFile}
          chown -R ${username} ${std.dirs.home-persist}/.config
          chmod 600 ${escapedKeyFile}
          chown -R ${username} ${std.dirs.home}/.config
        '';
      };
    };
  };
}
