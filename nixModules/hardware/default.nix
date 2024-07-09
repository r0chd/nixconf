{
  userConfig,
  lib,
  helpers,
}: let
  inherit (lib) optional;
in {
  imports =
    []
    ++ optional (!helpers.isDisabled "audio") ./audio/default.nix
    ++ optional (helpers.isEnabled "power") ./power/default.nix;

  hardware.enableAllFirmware = true;
}
