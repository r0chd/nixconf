{
  conf,
  lib,
  std,
}: let
  inherit (conf) audio bluetooth power;
  inherit (lib) optional;
in {
  imports =
    []
    ++ optional audio ./audio
    ++ optional bluetooth ./bluetooth
    ++ optional power ./power;

  hardware.enableAllFirmware = true;
}
