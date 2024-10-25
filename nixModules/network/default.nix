{
  conf,
  pkgs,
  lib,
  std,
}: let
  inherit (conf) hostname username;
  inherit (lib) optional;
in {
  imports =
    [
      (import ./ssh {inherit username lib hostname std;})
    ]
    ++ optional (conf.wireless) (import ./wireless {inherit pkgs hostname;});
}
