{
  pkgs,
  inputs,
  userConfig,
}: let
  inherit (userConfig) colorscheme username browser;
in {
  environment.shellAliases = {
    browser = "nb ${browser}";
  };
  imports =
    [
      (import ./ruin/default.nix {inherit colorscheme username;})
    ]
    ++ (
      if browser == "firefox"
      then [(import ./firefox/home.nix {inherit username inputs pkgs;})]
      else if browser == "qutebrowser"
      then [(import ./qutebrowser/home.nix {inherit username;})]
      else if browser == "chromium"
      then [(import ./chromium/home.nix {inherit username pkgs;})]
      else []
    );
}
