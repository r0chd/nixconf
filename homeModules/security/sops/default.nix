{
  pkgs,
  config,
  std,
  lib,
  hostname,
  inputs,
  username,
  ...
}:
{
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    secrets = {
      "${username}/ssh" = { };
      "${username}/password" = { };
    };
    defaultSopsFile = ../../../hosts/${hostname}/users/${config.home.username}/secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age = {
      sshKeyPaths = [ "/home/${username}/.ssh/id_ed25519" ];
      keyFile = "/home/${username}/.config/sops/age/keys.txt";
    };
  };
  home = {
    activation.sopsGenerateKey =
      let
        escapedKeyFile = lib.escapeShellArg "/home/${username}/.config/sops/age/keys.txt";
        sshKeyPath = "/home/${username}/.ssh/id_ed25519";
      in
      ''
        mkdir -p $(dirname ${escapedKeyFile})
        ${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i ${sshKeyPath} > ${escapedKeyFile}
      '';

    shellAliases.opensops = "sops ${std.dirs.config}/hosts/${hostname}/users/${username}/secrets/secrets.yaml";
    packages = with pkgs; [ sops ];
  };
}
