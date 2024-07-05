{
  userConfig,
  pkgs,
  lib,
}: let
  inherit (userConfig) hostname username;
  isDisabled = attribute: lib.hasAttr attribute userConfig && userConfig.tmux != false;
in {
  imports =
    [
      (import ./ssh/default.nix {inherit username;})
    ]
    ++ (
      if isDisabled "wireless"
      then []
      else [(import ./wireless/default.nix {inherit pkgs hostname;})]
    );
}
