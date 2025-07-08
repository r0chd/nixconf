{ lib, config, ... }:
let
  cfg = config.programs.btop;
in
{
  config = lib.mkIf cfg.enable {
    programs.btop.settings = {
      vim_keys = true;
    };
  };
}
