{ inputs, pkgs, conf, std, }:
let inherit (conf) hostname;
in {
  imports = [ inputs.sops-nix.nixosModules.sops ];

  sops = {
    secrets.nixos-access-token-github.path =
      "${std.dirs.home}/.config/nix/nix.conf";
    secrets.password.neededForUsers = true;
    defaultSopsFile = ../../../hosts/${hostname}/secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age = {
      sshKeyPaths = [ "${std.dirs.home}/.ssh/id_ed25519" ];
      keyFile = "${std.dirs.home}/.config/sops/age/keys.txt";
      generateKey = true;
    };
  };

  environment = {
    shellAliases.opensops =
      "sops $FLAKE/hosts/${hostname}/secrets/secrets.yaml";

    systemPackages = with pkgs; [ sops ];
  };
}
