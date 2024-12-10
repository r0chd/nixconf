{
  inputs,
  pkgs,
  std,
  config,
  lib,
  systemUsers,
  hostname,
  ...
}:
let
  root = (if config.system.impermanence.enable then "/persist/system/root" else "/root");
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  system.impermanence.persist.directories = [
    {
      directory = "/root/.config/sops";
      user = "root";
      group = "root";
      mode = "u=rwx, g=, o=";
    }
  ];

  sops = {
    secrets =
      {
        password.neededForUsers = true;
      }
      // lib.genAttrs (builtins.attrNames systemUsers) (user: {
        neededForUsers = true;
        sopsFile = ../../../hosts/${hostname}/users/${user}/secrets/secrets.yaml;
      });
    defaultSopsFile = ../../../hosts/${hostname}/secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age = {
      sshKeyPaths = [ "${root}/.ssh/id_ed25519" ];
      keyFile = "${root}/.config/sops/age/keys.txt";
    };
  };

  environment = {
    systemPackages = with pkgs; [ sops ];
    shellAliases.opensops = "sops ${std.dirs.config}/hosts/${hostname}/secrets/secrets.yaml";
  };

  system.activationScripts.sopsGenerateKey =
    let
      escapedKeyFile = lib.escapeShellArg "${root}/.config/sops/age/keys.txt";
      sshKeyPath = "${root}/.ssh/id_ed25519";
    in
    ''
      mkdir -p $(dirname ${escapedKeyFile})
      ${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i ${sshKeyPath} > ${escapedKeyFile}
    '';
}
