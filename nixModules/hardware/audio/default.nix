{ pkgs, config, lib, ... }: {
  options.audio.enable = lib.mkEnableOption "Enable audio";

  config = lib.mkIf config.audio.enable {
    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };

    environment.systemPackages = with pkgs; [ pavucontrol pamixer ];
  };
}
