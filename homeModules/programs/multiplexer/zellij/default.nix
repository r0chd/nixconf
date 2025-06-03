{ lib, config, ... }:
let
  cfg = config.programs.multiplexer;
in
{
  config = lib.mkIf (cfg.enable && cfg.variant == "zellij") {
    programs.zellij = {
      enable = true;
      settings = {
        default_mode = "normal";
        simplified_ui = true;
        pane_frames = false;
        session_serialization = false;
      };
    };
  };
}
