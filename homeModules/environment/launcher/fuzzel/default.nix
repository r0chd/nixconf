{ config, lib, ... }:
let
  cfg = config.environment.launcher;
in
{
  config = lib.mkIf (cfg.enable && cfg.program == "fuzzel") {
    programs.fuzzel = {
      enable = true;
      settings = {
        main.launch-prefix = "uwsm app -t service --";
      };
    };
  };
}
