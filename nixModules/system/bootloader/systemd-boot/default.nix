{ config, lib, ... }:
let
  cfg = config.system.bootloader;
in
{
  boot.loader.systemd-boot = lib.mkIf (cfg == "systemd-boot") {
    enable = true;
    editor = true;
  };
}
