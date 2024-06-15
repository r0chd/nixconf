{
  pkgs,
  inputs,
  config,
  ...
}: let
  inherit (config) colorscheme username font browser;
in {
  environment.shellAliases = {
    browser = "nb ${browser}";
  };
  imports =
    [
      (import ./ruin/default.nix {inherit colorscheme username;})
      (import ./waystatus/default.nix {inherit colorscheme username font;})
    ]
    ++ (
      if browser == "firefox"
      then [(import ./firefox/home.nix {inherit username inputs pkgs;})]
      else if browser == "qutebrowser"
      then [(import ./qutebrowser/home.nix {inherit username inputs pkgs;})]
      else []
    );
}
