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
    unplug = {
      enable = lib.mkEnableOption "Action when unplugging";
      action = lib.mkOption {
        type = lib.types.str;
        default = "${pkgs.systemd}/bin/loginctl lock-sessions";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    system.impermanence.persist.directories = lib.mkIf cfg.rootAuth [
      {
        directory = "/root/.config/Yubico";
        user = "root";
        group = "root";
        mode = "u=rwx, g=, o=";
      }
    ];

    sops.secrets = lib.mkIf cfg.rootAuth {
      "yubico/u2f_keys" = {
        path = "/root/.config/Yubico/u2f_keys";
      };
    };

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
           ENV{ID_BUS}=="usb",\
           ENV{ID_MODEL_ID}=="0010|0111|0112|0113|0114|0115|0116|0401|0402|0403|0404|0405|0406|0407|0410",\
           ENV{ID_VENDOR_ID}=="1050",\
           ENV{ID_VENDOR}=="Yubico",\
           RUN+="${cfg.unplug.action}"
        '';
        packages = with pkgs; [ yubikey-personalization ];
      };
      yubikey-agent.enable = true;
    };

    security.pam = {
      sshAgentAuth.enable = false; # TODO: its borked rn
      u2f = lib.mkIf cfg.rootAuth {
        enable = true;
        settings = {
          cue = true;
          authFile = "/root/.config/Yubico/u2f_keys";
        };
      };
      services = {
        login.u2fAuth = true;
        sudo = {
          rules.auth.rssh = {
            order = config.rules.auth.ssh_agent_auth.order - 1;
            control = "sufficient";
            modulePath = "${pkgs.pam_rssh}/lib/libpam_rssh.so";
            settings.authorized_keys_command = pkgs.writeShellScript "get-authorized-keys" "cat ~/etc/ssh/authorized_keys.d/$1";
          };
          u2fAuth = true;
          sshAgentAuth = true;
        };
      };
    };
  };
}
