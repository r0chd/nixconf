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
  options.programs.deploy-rs = {
    sshKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
    };
  };

  config = {
    environment.systemPackages = [ pkgs.deploy-rs.deploy-rs ];

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
      group = "nogroup";
      hashedPassword = null;
      home = "/var/lib/deploy-rs";
      createHome = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIBr2Qqn+YpNdvJ3VdSvtuEfTiVo0upJM2VGx6W9lhAD unixpariah@laptop"
      ];
    };

    systemd.tmpfiles.rules = lib.mkIf (cfg.sshKeyFile != null) [
      "d /var/lib/deploy-rs/.ssh 0700 deploy-rs nogroup -"
      "L+ /var/lib/deploy-rs/.ssh/id_rsa - ${cfg.sshKeyFile}"
    ];

    nix.settings.trusted-users = [ "deploy-rs" ];

    environment.etc."ssh/ssh_config.d/deploy-rs.conf".text = ''
      Host *
        User deploy-rs
        IdentityFile /var/lib/deploy-rs/.ssh/id_rsa
        StrictHostKeyChecking no
    '';

  };
}
