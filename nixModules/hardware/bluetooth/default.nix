{ conf, lib }: {
  options.bluetooth.enable = lib.mkEnableOption "Enable bluetooth";

  config = lib.mkIf conf.bluetooth.enable { hardware.bluetooth.enable = true; };
}
