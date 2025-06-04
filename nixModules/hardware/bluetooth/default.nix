{
  config,
  lib,
  system_type,
  ...
}:
{
  hardware.bluetooth.enable = lib.mkDefault (system_type == "desktop");

  environment.persist.directories = lib.mkIf config.hardware.bluetooth.enable [
    "/var/lib/bluetooth"
  ];
}
