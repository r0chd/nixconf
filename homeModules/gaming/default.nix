{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.gaming;
in
{
  imports = [
    ./steam
    ./heroic
    ./lutris
    ./minecraft
  ];
}
