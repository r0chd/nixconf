{
  lib,
  config,
  pkgs,
  std,
  ...
}:
{
  options.yubikey.enable = lib.mkEnableOption "yubikey";

  config = lib.mkIf config.yubikey.enable {
    environment.systemPackages = with pkgs; [
      yubioath-flutter
      yubikey-manager
      pam_u2f
    ];

    services = {
      pcscd.enable = true;
      udev.packages = with pkgs; [ yubikey-personalization ];
      yubikey-agent.enable = true;
    };

    security.pam = {
      sshAgentAuth.enable = true;
      u2f = {
        enable = true;
        settings = {
          cue = false;
          authFile = "${std.dirs.home}/.config/Yubico/u2f_keys";
        };
      };
      services = {
        login.u2fAuth = true;
        sudo = {
          u2fAuth = true;
          sshAgentAuth = true;
        };
      };
    };
  };
}
