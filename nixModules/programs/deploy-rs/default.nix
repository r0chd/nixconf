{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.deploy-rs;
in
{
  options.programs.deploy-rs.sshKeyFile = lib.mkOption {
    type = lib.types.nullOr lib.types.path;
    default = null;
  };

  config = {
    environment.systemPackages = lib.mkIf (cfg.sshKeyFile != null) [ pkgs.deploy-rs.deploy-rs ];

    security.sudo.extraRules = [
      {
        users = [ "deploy-rs" ];
        commands = [
          {
            command = "ALL";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];

    users.users.deploy-rs = {
      isSystemUser = true;
      useDefaultShell = true;
      description = "NixOS deployer";
      group = "wheel";
      hashedPassword = null;
      openssh.authorizedKeys.keys = [ ];
    };

    nix.settings.trusted-users = [ "deploy-rs" ];

    programs.ssh.extraConfig = lib.mkIf (cfg.sshKeyFile != null) ''
      Host *
        Match User deploy-rs
          IdentityFile ${cfg.sshKeyFile}
          IdentitiesOnly yes
          StrictHostKeyChecking no
          UserKnownHostsFile /dev/null
    '';
  };
}
