{
  conf,
  pkgs,
  inputs,
  lib,
}: let
  inherit (conf) colorscheme username font ruin statusBar browser;
  inherit (lib) optional;
in {
  environment.shellAliases =
    {}
    // lib.optionalAttrs (conf ? browser) {browser = "nb ${conf.browser}";};
  imports =
    []
    ++ (
      if browser == "firefox"
      then [(import ./firefox/home.nix {inherit username inputs pkgs;})]
      else if browser == "qutebrowser"
      then [(import ./qutebrowser/home.nix {inherit username;})]
      else if browser == "chromium"
      then [(import ./chromium/home.nix {inherit username pkgs;})]
      else []
    )
    ++ (
      if statusBar == "waystatus"
      then [(import ./waystatus/default.nix {inherit username colorscheme font pkgs inputs;})]
      else []
    )
    ++ optional ruin (import ./ruin/default.nix {inherit colorscheme username pkgs inputs;});
}
