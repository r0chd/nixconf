{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.editor == "nano") {

    home.packages = with pkgs; [ nano ];
  };
}
