{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.bat;
in
{
  # lib.mkIf cfg.enable
  programs.bat.enable = true;
  home.shellAliases.less = "${pkgs.bat}/bin/bat";
}
