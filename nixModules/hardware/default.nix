{config, ...}: let
  inherit (config) audio power;
in {
  imports =
    [
      ./nvidia/default.nix
    ]
    ++ (
      if audio == true
      then [./audio/default.nix]
      else []
    )
    ++ (
      if power == true
      then [./power/default.nix]
      else []
    );

  hardware.enableAllFirmware = true;
}
