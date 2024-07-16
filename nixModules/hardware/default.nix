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
    ++ optional audio ./audio/default.nix
    ++ optional bluetooth ./bluetooth/default.nix
    ++ optional power ./power/default.nix;

  hardware.enableAllFirmware = true;
}
