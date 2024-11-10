{ inputs, pkgs, std, config, lib, username, ... }: {
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    secrets.nixos-access-token-github = {
      owner = "${username}";
      path = "${std.dirs.home}/.config/nix/nix.conf";
    };
    secrets.password.neededForUsers = true;
    defaultSopsFile = "${std.dirs.host}/secrets/secrets.yaml";
    defaultSopsFormat = "yaml";
    age = {
      sshKeyPaths = [ "${std.dirs.home-persist}/.ssh/id_ed25519" ];
      keyFile = "${std.dirs.home-persist}/.config/sops/age/keys.txt";
    };
  };

  environment = {
    shellAliases.opensops = "sops $FLAKE/hosts/$hostname/secrets/secrets.yaml";
    systemPackages = with pkgs; [ sops ];
  };

  impermanence.persist-home.directories =
    lib.mkIf config.impermanence.enable [ ".config/sops/age" ];

  system.activationScripts.sopsGenerateKey = let
    escapedKeyFile = lib.escapeShellArg config.sops.age.keyFile;
    sshKeyPath = builtins.elemAt config.sops.age.sshKeyPaths 0;
  in ''
    mkdir -p $(dirname ${escapedKeyFile})
    ${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i ${sshKeyPath} > ${escapedKeyFile}
    chown -R ${username} ${std.dirs.home-persist}/.config
    chmod 600 ${escapedKeyFile}
    chown -R ${username} ${std.dirs.home}/.config
  '';
}
