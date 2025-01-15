{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.programs.obs-studio;
in
{
  options.obs.enable = lib.mkEnableOption "Enable obs module";
  config = lib.mkIf cfg.enable {
    programs.obs-studio = {
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-vaapi
        obs-vkcapture
        obs-pipewire-audio-capture
      ];
    };
  };
}
