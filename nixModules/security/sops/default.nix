{
  inputs,
  username,
  pkgs,
}: {
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops.defaultSopsFile = ../../../hosts/${username}/secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age = {
    sshKeyPaths = ["/home/${username}/.ssh/id_ed25519"];
    keyFile = "/home/${username}/.config/sops/age/keys.txt";
    generateKey = true;
  };

  environment.systemPackages = with pkgs; [sops];
}
