{
  inputs,
  pkgs,
  config,
  lib,
  systemUsers,
  ...
}:
let
  root = if config.services.impermanence.enable then "/persist/system/root" else "/root";
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  environment.persist.directories = [
    {
      directory = "/root/.config/sops";
      user = "root";
      group = "root";
      mode = "u=rwx, g=, o=";
    }
  ];

  sops = {
    secrets =
      systemUsers
      |> builtins.attrNames
      |> builtins.concatMap (user: [
        {
          name = "${user}/password";
          value = {
            neededForUsers = true;
            sopsFile = ../../../hosts/${config.networking.hostName}/users/${user}/secrets/secrets.yaml;
          };
        }
        {
          name = "${user}/ssh";
          value = {
            owner = user;
            path = "/home/${user}/.ssh/id_ed25519";
            sopsFile = ../../../hosts/${config.networking.hostName}/users/${user}/secrets/secrets.yaml;
          };
        }
      ])
      |> lib.listToAttrs;

    defaultSopsFile = ../../../hosts/${config.networking.hostName}/secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age = {
      sshKeyPaths = [ "${root}/.ssh/id_ed25519" ];
      keyFile = "${root}/.config/sops/age/keys.txt";
    };
  };

  environment = {
    systemPackages = [ pkgs.sops ];
    shellAliases.opensops = "SOPS_AGE_KEY_FILE=\"${config.sops.age.keyFile}\" sops /var/lib/nixconf/hosts/${config.networking.hostName}/secrets/secrets.yaml";
  };

  system.activationScripts.sopsGenerateKeys =
    let
      escapedKeyFile = lib.escapeShellArg "${root}/.config/sops/age/keys.txt";
      sshKeyPath = "${root}/.ssh/id_ed25519";
    in
    ''
      mkdir -p $(dirname ${escapedKeyFile})
      ${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i ${sshKeyPath} > ${escapedKeyFile}
    ''
    + lib.concatMapStrings (
      user:
      let
        escapedUserKeyFile = lib.escapeShellArg "/home/${user}/.config/sops/age/keys.txt";
        sshUserKeyPath = "/home/${user}/.ssh/id_ed25519";
      in
      ''
        mkdir -p $(dirname ${escapedUserKeyFile})
        ${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i ${sshUserKeyPath} > ${escapedUserKeyFile}
        chown -R ${user}:users /home/${user}/.config
      ''
    ) (lib.attrNames systemUsers);
}
