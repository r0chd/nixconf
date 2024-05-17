{
  pkgs,
  inputs,
  username,
  browser,
  ...
}: {
  imports =
    []
    ++ (
      if browser == "firefox"
      then [(import ./firefox/home.nix {inherit username inputs pkgs;})]
      else if browser == "qutebrowser"
      then [(import ./qutebrowser/home.nix {inherit username inputs pkgs;})]
      else []
    );
}
