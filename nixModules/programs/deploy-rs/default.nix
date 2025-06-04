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
      group = "wheel";
      hashedPassword = null;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIBr2Qqn+YpNdvJ3VdSvtuEfTiVo0upJM2VGx6W9lhAD unixpariah@laptop"
      ];
    };

    nix.settings.trusted-users = [ "deploy-rs" ];

    programs.ssh.extraConfig = lib.mkIf (cfg.sshKeyFile != null) ''
      Host * 
        Match user deploy-rs
          IdentityFile ${cfg.sshKeyFile}
    '';
  };
}
