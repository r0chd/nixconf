{
  conf,
  pkgs,
  inputs,
  lib,
  std,
}: let
  inherit (conf) username ruin;
  inherit (lib) optional;
in {
  environment.shellAliases =
    {}
    // lib.optionalAttrs (conf ? browser) {browser = "nb ${conf.browser}";};
  imports =
    [
      (import ./browser {inherit conf inputs pkgs;})
      (import ./terminal {inherit conf inputs pkgs;})
    ]
    ++ (
      if conf ? statusBar && conf.statusBar == "waystatus"
      then [(import ./waystatus {inherit conf std pkgs inputs;})]
      else []
    )
    ++ (
      if conf ? notifications && conf.notifications == "mako"
      then [(import ./mako {inherit username;})]
      else []
    )
    ++ optional ruin (import ./ruin {inherit conf pkgs inputs std;});
}
