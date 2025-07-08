{
  pkgs,
  config,
  lib,
  hostName,
  inputs,
  ...
}:
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    secrets = {
      "${config.home.username}/ssh" = { };
      "${config.home.username}/password" = { };
    };
    defaultSopsFile = "${inputs.self}/hosts/${hostName}/users/${config.home.username}/secrets/secrets.yaml";
    defaultSopsFormat = "yaml";
    age = {
      sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
      keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    };
  };
  home = {
    shellAliases.opensops = "sops /var/lib/nixconf/hosts/${hostName}/users/${config.home.username}/secrets/secrets.yaml";
    packages = [ pkgs.sops ];
  };
}
