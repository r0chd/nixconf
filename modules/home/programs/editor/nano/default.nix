{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.programs.editor == "nano") { home.packages = [ pkgs.nano ]; };
}
