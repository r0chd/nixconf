{
  userConfig,
  pkgs,
  lib,
  helpers,
}: let
  inherit (userConfig) hostname username;
  inherit (lib) optional;
  inherit (helpers) isDisabled;
in {
  imports =
    [
      (import ./ssh/default.nix {inherit username lib;})
    ]
    ++ optional (!isDisabled "wireless") (import ./wireless/default.nix {inherit pkgs hostname;});
}
