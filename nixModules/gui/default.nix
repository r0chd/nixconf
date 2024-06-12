{
  pkgs,
  inputs,
  username,
  browser,
  colorscheme,
  ...
}: {
  environment.shellAliases = {
    browser = "nb ${browser}";
  };
  imports =
    [(import ./ruin/default.nix {inherit colorscheme username;})]
    ++ (
      if browser == "firefox"
      then [(import ./firefox/home.nix {inherit username inputs pkgs;})]
      else if browser == "qutebrowser"
      then [(import ./qutebrowser/home.nix {inherit username inputs pkgs;})]
      else []
    );
}
