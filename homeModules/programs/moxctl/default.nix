{
  pkgs,
  lib,
  config,
  ...
}:
{
  config = lib.mkIf (config.services.moxidle.enable || config.services.moxnotify.enable) {
    home.packages = with pkgs; [ moxctl ];
  };
}
