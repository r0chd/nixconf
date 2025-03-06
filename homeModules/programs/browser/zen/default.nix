{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.zen;
in
{
  options.programs.zen.enable = lib.mkEnableOption "zen";

  config = lib.mkIf cfg.enable {
    home = {
      packages = with pkgs; [ inputs.zen-browser.packages.${system}.default ];
      persist.directories = [
        ".cache/zen"
        ".zen"
      ];
    };
  };
}
