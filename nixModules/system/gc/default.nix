{
  lib,
  config,
  systemUsers,
  pkgs,
  hostname,
  ...
}:
let
  cfg = config.system.gc;
in
{
  options.system.gc = {
    enable = lib.mkEnableOption "Garbage collector";
    interval = lib.mkOption {
      type = lib.types.int;
      default = 7;
    };
  };

  config = lib.mkIf cfg.enable {
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than ${toString config.system.gc.interval}d";
    };

    systemd.services.clear-home-generations = {
      # TODO: make it clear home generations stored in ~/.cache/home-generations/
      enable = false;
      description = "Activate home manager";
      wantedBy = [ "default.target" ];
      requiredBy = [ "systemd-user-sessions.service" ];
      before = [ "systemd-user-sessions.service" ];
      serviceConfig = {
        Type = "oneshot";
        #ProtectHome = "yes";
        ProtectSystem = "yes";
        NoNewPrivileges = "yes";
        ProtectKernelLogs = "yes";
        ProtectKernelModules = "yes";
        ProtectKernelTunables = "yes";
      };
      environment = {
        PATH = lib.mkForce "${pkgs.nix}/bin:${pkgs.git}/bin:${pkgs.home-manager}:${pkgs.sudo}/bin:${pkgs.coreutils}/bin:$PATH";
        HOME_MANAGER_BACKUP_EXT = "bak";
      };
      script = lib.concatMapStrings (user: ''
        if [ ! -d "/persist/home/${user}/.cache/home-generations/result" ]; then
            nix build "/var/lib/nixconf#homeConfigurations.${user}@${hostname}.config.home.activationPackage" --log-format internal-json --verbose --out-link /persist/home/${user}/.cache/home-generations/result
        fi

        chown -R ${user}:users /home/${user}/.ssh
        sudo -u ${user} /persist/home/${user}/.cache/home-generations/result/specialisation/niri/activate
      '') (lib.attrNames systemUsers);
    };
  };
}
