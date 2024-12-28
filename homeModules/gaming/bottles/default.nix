{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.gaming.bottles;
in
{
  options.gaming.bottles.enable = lib.mkEnableOption "Enable bottles";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ bottles ];
  };
}
