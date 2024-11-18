{
  inputs,
  pkgs,
  std,
  config,
  lib,
  ...
}:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  options.sops = {
    enable = lib.mkEnableOption "sops";
    managePassword = lib.mkEnableOption "manage passwords with sops";
  };

  config = lib.mkIf config.sops.enable {
    sops = {
      secrets = lib.genAttrs (builtins.attrNames config.systemUsers) (user: {
        neededForUsers = true;
        sopsFile = "${std.dirs.host}/users/${user}/secrets/secrets.yaml";
      });
      defaultSopsFile = "${std.dirs.host}/secrets/secrets.yaml";
      defaultSopsFormat = "yaml";
      age = {
        sshKeyPaths = [ "${std.dirs.home-persist}/.ssh/id_ed25519" ];
        keyFile = "${std.dirs.home-persist}/.config/sops/age/keys.txt";
      };
    };

    system.activationScripts.sopsGenerateKey =
      let
        userScripts = (
          lib.attrNames config.systemUsers |> lib.concatMapStrings (user: "${generateAgeKey user}")
        );
        generateAgeKey =
          user:
          let
            escapedKeyFile = lib.escapeShellArg config.home-manager.users.${user}.sops.age.keyFile;
            sshKeyPath = builtins.elemAt config.home-manager.users.${user}.sops.age.sshKeyPaths 0;
          in
          ''
            mkdir -p $(dirname ${escapedKeyFile})
            ${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i ${sshKeyPath} > ${escapedKeyFile}
            chown -R ${user} /persist/home/${user}/.config
            chmod 600 ${escapedKeyFile}
            chown -R ${user} /home/${user}/.config
          '';
      in
      userScripts;
  };
}
