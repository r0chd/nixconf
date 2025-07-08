{
  pkgs,
  config,
  lib,
  profile,
  ...
}:
let
  cfg = config.hardware.audio;
in
{
  options.hardware.audio.enable = lib.mkOption {
    type = lib.types.bool;
    default = profile == "desktop";
  };

  config = lib.mkIf cfg.enable {
    services = {
      pulseaudio.enable = lib.mkDefault false;
      pipewire = {
        enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
        wireplumber.enable = true;
        pulse.enable = true;
        jack.enable = true;
        audio.enable = true;
      };
    };

    environment.systemPackages = [ pkgs.pavucontrol ];
  };
}
