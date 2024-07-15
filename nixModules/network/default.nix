{
  conf,
  pkgs,
  lib,
  helpers,
}: let
  inherit (conf) hostname username;
  inherit (lib) optional;
in {
  imports =
    [
      (import ./ssh/default.nix {inherit username lib hostname;})
    ]
    ++ optional (conf.wireless) (import ./wireless/default.nix {inherit pkgs hostname;});
}
