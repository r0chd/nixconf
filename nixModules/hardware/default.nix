{
  userConfig,
  lib,
  helpers,
}: {
  imports =
    []
    ++ (
      if helpers.isDisabled "audio"
      then []
      else [./audio/default.nix]
    )
    ++ (
      if helpers.isEnabled "power"
      then [./power/default.nix]
      else []
    );

  hardware.enableAllFirmware = true;
}
