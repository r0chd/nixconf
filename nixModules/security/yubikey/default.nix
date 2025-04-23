{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.security.yubikey;
in
{
  options.security.yubikey = {
    enable = lib.mkEnableOption "yubikey";
    rootAuth = lib.mkEnableOption "root authentication";
    id = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.str;
    };
    unplug = {
      enable = lib.mkEnableOption "Action when unplugging";
      action = lib.mkOption {
        type = lib.types.str;
        default = "${pkgs.systemd}/bin/loginctl lock-sessions";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      yubioath-flutter
      yubikey-manager
      pam_u2f
    ];

    services = {
      pcscd.enable = true;
      udev = {
        extraRules = lib.mkIf cfg.unplug.enable ''
          ACTION=="remove",\
          ENV{SUBSYSTEM}=="usb",\
          ENV{PRODUCT}=="1050/407/571",\
          RUN+="${cfg.unplug.action}"
        '';
        packages = with pkgs; [ yubikey-personalization ];
      };
      yubikey-agent.enable = true;
    };

    security.pam = {
      yubico = {
        enable = cfg.id != null;
        debug = true;
        mode = "challenge-response";
        id = [ cfg.id ];
      };
      u2f = {
        enable = cfg.rootAuth;
        settings = {
          cue = true;
          authFile = "/root/.config/Yubico/u2f_keys";
        };
      };
      services = {
        login.u2fAuth = true;
        sudo = {
          rules.auth.rssh = {
            order = config.security.pam.services.sudo.rules.auth.ssh_agent_auth.order - 1;
            control = "sufficient";
            modulePath = "${pkgs.pam_rssh}/lib/libpam_rssh.so";
            settings.authorized_keys_command = pkgs.writeShellScript "get-authorized-keys" "cat /etc/ssh/authorized_keys.d/$1";
          };
          u2fAuth = true;
        };
      };
    };
  };
}
