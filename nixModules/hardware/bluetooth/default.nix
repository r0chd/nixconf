{ conf, lib }: {
  options.bluetooth.enable = lib.mkEnableOption "Enable bluetooth";

  config = lib.mkIf conf.bluetooth.enable {
    hardware.bluetooth.enable = true;

    environment.persistence."/persist/system".directories =
      lib.mkIf conf.impermanence.enable [ "/var/lib/bluetooth" ];
  };
}
