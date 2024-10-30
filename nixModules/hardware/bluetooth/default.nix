{ config, lib, ... }: {
  options.bluetooth.enable = lib.mkEnableOption "Enable bluetooth";

  config = lib.mkIf config.bluetooth.enable {
    hardware.bluetooth.enable = true;

    environment.persistence."/persist/system".directories =
      lib.mkIf config.impermanence.enable [ "/var/lib/bluetooth" ];
  };
}
