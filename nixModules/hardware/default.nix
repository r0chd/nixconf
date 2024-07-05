{
  userConfig,
  lib,
}: let
  isDisabled = attribute: lib.hasAttr attribute userConfig && userConfig.tmux != false;
in {
  imports =
    [
    ]
    ++ (
      if isDisabled "audio"
      then []
      else [./audio/default.nix]
    )
    ++ (
      if lib.hasAttr "power" userConfig && lib.isBool userConfig.power && userConfig.power == true
      then [./power/default.nix]
      else []
    );

  hardware.enableAllFirmware = true;
}
