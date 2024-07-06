{
  pkgs,
  inputs,
  userConfig,
  lib,
  helpers,
}: let
  inherit (userConfig) colorscheme username;
in {
  environment.shellAliases = {
    browser =
      if lib.hasAttr "browser" userConfig
      then "nb ${userConfig.browser}"
      else "echo 'Browser not set'";
  };
  imports =
    []
    ++ (
      if helpers.checkAttribute "browser" "firefox"
      then [(import ./firefox/home.nix {inherit username inputs pkgs;})]
      else if helpers.checkAttribute "browser" "qutebrowser"
      then [(import ./qutebrowser/home.nix {inherit username;})]
      else if helpers.checkAttribute "browser" "chromium"
      then [(import ./chromium/home.nix {inherit username pkgs;})]
      else []
    )
    ++ (
      if helpers.isDisabled "ruin"
      then []
      else [(import ./ruin/default.nix {inherit colorscheme username pkgs inputs;})]
    );
}
