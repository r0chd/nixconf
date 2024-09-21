{
  conf,
  pkgs,
  inputs,
  lib,
  std,
}: let
  inherit (conf) ruin;
  inherit (lib) optional;
in {
  environment.shellAliases =
    {}
    // lib.optionalAttrs (conf ? browser) {browser = "nb ${conf.browser}";};
  imports =
    [
      (import ./browser {inherit conf inputs pkgs;})
      (import ./terminal {inherit conf inputs pkgs;})
      (import ./cursors {inherit conf pkgs;})
      (import ./status {inherit conf std pkgs inputs;})
      (import ./notifications {inherit conf;})
    ]
    ++ optional ruin (import ./ruin {inherit conf pkgs inputs std;});
}
