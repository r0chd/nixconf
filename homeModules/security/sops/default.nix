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
    defaultSopsFile = ../../../hosts/${hostName}/users/${config.home.username}/secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age = {
      sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
      keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
    };
  };
  home = {
    activation.sopsGenerateKey =
      let
        escapedKeyFile = lib.escapeShellArg "${config.home.homeDirectory}/.config/sops/age/keys.txt";
        sshKeyPath = "${config.home.homeDirectory}/.ssh/id_ed25519";
      in
      ''
        mkdir -p $(dirname ${escapedKeyFile})
        ${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i ${sshKeyPath} > ${escapedKeyFile}
      '';

    shellAliases.opensops = "sops /var/lib/nixconf/hosts/${hostName}/users/${config.home.username}/secrets/secrets.yaml";
    packages = with pkgs; [ sops ];
  };
}
