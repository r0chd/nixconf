{ lib, config, pkgs, username, ... }: {
  options = { obs.enable = lib.mkEnableOption "Enable obs module"; };
  config = lib.mkIf config.obs.enable {
    home-manager.users.${username}.programs.obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-vaapi
        obs-vkcapture
        obs-pipewire-audio-capture
      ];
    };
  };
}
