{
  config,
  pkgs,
  inputs,
  ...
}: let
  inherit (config) wireless hostname;
in {
  imports =
    [
    ]
    ++ (
      if wireless == true
      then [(import ./wireless/default.nix {inherit pkgs inputs hostname;})]
      else []
    );
}
