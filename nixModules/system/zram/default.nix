{ config, lib, ... }:
{
  options.zram.enable = lib.mkEnableOption "Enable zram";

  config = lib.mkIf config.zram.enable { zramSwap.enable = true; };
}
