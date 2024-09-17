{
  conf,
  pkgs,
  inputs,
}: {
  imports = let
    inherit (conf) username font;
  in
    []
    ++ (
      if conf ? terminal && conf.terminal == "kitty"
      then [(import ./kitty {inherit username font;})]
      else if conf ? terminal && conf.terminal == "foot"
      then [(import ./foot {inherit username font;})]
      else if conf ? terminal && conf.terminal == "ghostty"
      then [(import ./ghostty {inherit pkgs inputs username conf;})]
      else []
    );
}
