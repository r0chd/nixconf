{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.browser;
in
{
  config = lib.mkIf (cfg.enable && cfg.variant == "zen") {
    home = {
      packages = with pkgs; [ inputs.zen-browser.packages.${system}.default ];
      persist.directories = [
        ".cache/zen"
        ".zen"
      ];
    };
  };
}
