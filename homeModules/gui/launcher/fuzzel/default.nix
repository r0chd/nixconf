{ config, lib, ... }:
{
  config = lib.mkIf (config.launcher.enable && config.launcher.program == "fuzzel") {
    programs.fuzzel = {
      enable = true;
    };
  };
}
