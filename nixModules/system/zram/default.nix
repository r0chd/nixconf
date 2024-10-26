{ conf, lib }: {
  options.zram.enable = lib.mkEnableOption "Enable zram";

  config = lib.mkIf conf.zram.enable { zramSwap.enable = true; };
}
