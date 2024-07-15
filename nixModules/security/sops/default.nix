{
  inputs,
  username,
  pkgs,
  hostname,
  helpers,
}: let
  inherit (helpers) home;
in {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops.secrets.password.neededForUsers = true;
  sops.defaultSopsFile = ../../../hosts/${hostname}/secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age = {
    sshKeyPaths = ["${home}/.ssh/id_ed25519"];
    keyFile = "${home}/.config/sops/age/keys.txt";
    generateKey = true;
  };

  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "opensops" ''
      sops "$FLAKE/hosts/${hostname}/secrets/secrets.yaml"
    '')
    sops
  ];
}
