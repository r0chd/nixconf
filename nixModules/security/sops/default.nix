{ inputs, pkgs, conf, std, config, lib }:
let inherit (conf) hostname username;
in {
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    secrets.nixos-access-token-github = {
      owner = "${conf.username}";
      path = "${std.dirs.home}/.config/nix/nix.conf";
    };
    secrets.password.neededForUsers = true;
    defaultSopsFile = ../../../hosts/${hostname}/secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age = {
      sshKeyPaths = [ "${std.dirs.home-persist}/.ssh/id_ed25519" ];
      keyFile = "${std.dirs.home-persist}/.config/sops/age/keys.txt";
    };
  };

  environment = {
    shellAliases.opensops = "sops ${std.dirs.host}/secrets/secrets.yaml";
    systemPackages = with pkgs; [ sops ];
  };

  home-manager.users.${username}.home.persistence.${std.dirs.home-persist}.directories =
    lib.mkIf conf.impermanence.enable [ ".config/sops/age" ];

  system.activationScripts.sopsGenerateKey = let
    escapedKeyFile = lib.escapeShellArg config.sops.age.keyFile;
    sshKeyPath = builtins.elemAt config.sops.age.sshKeyPaths 0;
  in ''
    mkdir -p $(dirname ${escapedKeyFile})
    ${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i ${sshKeyPath} > ${escapedKeyFile}
    chown -R ${conf.username} ${std.dirs.home-persist}/.config
    chmod 600 ${escapedKeyFile}
    chown -R ${conf.username} ${std.dirs.home}/.config
  '';
}
