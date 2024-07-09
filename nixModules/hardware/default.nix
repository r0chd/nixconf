{
  userConfig,
  lib,
  helpers,
}: {
  imports =
    []
    ++ (
      if !helpers.isDisabled "audio"
      then [./audio/default.nix]
      else []
    )
    ++ (
      if helpers.isEnabled "power"
      then [./power/default.nix]
      else []
    );

  hardware.enableAllFirmware = true;
}
