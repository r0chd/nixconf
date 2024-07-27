{
  conf,
  pkgs,
  inputs,
  lib,
  std,
}: let
  inherit (conf) username ruin statusBar browser notifications;
  inherit (lib) optional;
in {
  environment.shellAliases =
    {}
    // lib.optionalAttrs (conf ? browser) {browser = "nb ${conf.browser}";};
  imports =
    []
    ++ (
      if browser == "firefox"
      then [(import ./firefox {inherit username inputs pkgs;})]
      else if browser == "qutebrowser"
      then [(import ./qutebrowser {inherit username;})]
      else if browser == "chromium"
      then [(import ./chromium {inherit username pkgs;})]
      else if browser == "ladybird"
      then [./ladybird]
      else []
    )
    ++ (
      if statusBar == "waystatus"
      then [(import ./waystatus {inherit conf std pkgs inputs;})]
      else []
    )
    ++ (
      if notifications == "mako"
      then [(import ./mako {inherit username;})]
      else []
    )
    ++ optional ruin (import ./ruin {inherit conf pkgs inputs std;});
}
