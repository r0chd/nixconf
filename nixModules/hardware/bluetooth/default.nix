{ config, lib, ... }:
{
  environment.persist.directories = lib.mkIf config.hardware.bluetooth.enable [
    "/var/lib/bluetooth"
  ];
}
