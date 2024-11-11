{ config, lib, ... }: {
  options.bluetooth.enable = lib.mkEnableOption "Enable bluetooth";

  config = lib.mkIf config.bluetooth.enable {
    hardware.bluetooth.enable = true;

    impermanence.persist.directories = [ "/var/lib/bluetooth" ];
  };
}
