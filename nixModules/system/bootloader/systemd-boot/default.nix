{ config, lib, ... }:
{
  config = lib.mkIf (config.boot.program == "systemd-boot") {
    boot.loader.systemd-boot.enable = true;
  };
}
