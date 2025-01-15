{ config, lib, ... }:
{
  system.impermanence.persist.directories = lib.mkIf config.hardware.bluetooth.enable [
    "/var/lib/bluetooth"
  ];
}
