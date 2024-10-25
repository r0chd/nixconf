{
  conf,
  inputs,
  pkgs,
  lib,
}: {
  environment.shellAliases =
    {}
    // lib.optionalAttrs (conf ? browser) {browser = "nb ${conf.browser}";};
  imports = let
    inherit (conf) username;
  in
    []
    ++ (
      if conf ? browser && conf.browser == "firefox"
      then [(import ./firefox {inherit username inputs pkgs;})]
      else if conf ? browser && conf.browser == "qutebrowser"
      then [(import ./qutebrowser {inherit username;})]
      else if conf ? browser && conf.browser == "chromium"
      then [(import ./chromium {inherit username pkgs;})]
      else if conf ? browser && conf.browser == "ladybird"
      then [./ladybird]
      else []
    );
}
