{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.browser.enable && config.browser.program == "ladybird") {
    home = {
      packages = with pkgs; [ ladybird ];
      shellAliases.ladybird = "Ladybird";
    };
  };
}
