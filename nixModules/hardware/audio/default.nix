{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.hardware.audio;
in
{
  options.hardware.audio.enable = lib.mkEnableOption "Enable audio";

  config = lib.mkIf cfg.enable {
    services.pipewire = {
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

    environment.systemPackages = with pkgs; [
      pavucontrol
      pamixer
    ];
  };
}
