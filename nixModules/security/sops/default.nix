{
  inputs,
  username,
  pkgs,
  hostname,
  std,
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops.secrets.password.neededForUsers = true;
  sops.defaultSopsFile = ../../../hosts/${hostname}/secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age = {
    sshKeyPaths = ["${std.home}/.ssh/id_ed25519"];
    keyFile = "${std.home}/.config/sops/age/keys.txt";
    generateKey = true;
  };

  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "opensops" ''
      sops "$FLAKE/hosts/${hostname}/secrets/secrets.yaml"
    '')
    sops
  ];
}
