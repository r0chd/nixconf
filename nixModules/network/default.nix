{
  userConfig,
  pkgs,
  lib,
  helpers,
}: let
  inherit (userConfig) hostname username;
in {
  imports =
    [
      (import ./ssh/default.nix {inherit username;})
    ]
    ++ (
      if helpers.isDisabled "wireless"
      then []
      else [(import ./wireless/default.nix {inherit pkgs hostname;})]
    );
}
