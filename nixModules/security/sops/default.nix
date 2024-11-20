{
  pkgs,
  std,
  config,
  lib,
  ...
}:
{
  impermanence.persist.directories = [ "/root/.config/sops" ];

  sops = {
    secrets =
      {
        password.neededForUsers = true;
        "yubico/u2f_keys" = {
          path = "/persist/root/.config/Yubico/u2f_keys";
        };
      }
      // lib.genAttrs (builtins.attrNames config.systemUsers) (user: {
        neededForUsers = true;
        sopsFile = "${std.dirs.host}/users/${user}/secrets/secrets.yaml";
      });
    defaultSopsFile = "${std.dirs.host}/secrets/secrets.yaml";
    defaultSopsFormat = "yaml";
    age = {
      sshKeyPaths = [ "/persist/system/root/.ssh/id_ed25519" ];
      keyFile = "/persist/system/root/.config/sops/age/keys.txt";
    };
  };

  environment = {
    systemPackages = with pkgs; [ sops ];
    shellAliases.opensops = "sops ${config.sops.defaultSopsFile}";
  };

  system.activationScripts = {
    sopsGenerateKey =
      let
        userScripts = (
          lib.attrNames config.systemUsers |> lib.concatMapStrings (user: "${generateAgeKey user}")
        );
        generateAgeKey =
          user:
          let
            escapedKeyFile = lib.escapeShellArg "/home/${user}/.config/sops/age/keys.txt";
            sshKeyPath = "/home/${user}/.ssh/id_ed25519";
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

    sopsGenerateRootKey =
      let
        escapedKeyFile = lib.escapeShellArg "/persist/system/root/.config/sops/age/keys.txt";
        sshKeyPath = "/persist/system/root/.ssh/id_ed25519";
      in
      ''
        mkdir -p $(dirname ${escapedKeyFile})
        ${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i ${sshKeyPath} > ${escapedKeyFile}
      '';
  };
}
