{
  config,
  lib,
  profile,
  platform,
  pkgs,
  ...
}:
let
  cfg = config.environment.wallpaper;
  inherit (lib) types;
in
{
  options.environment.wallpaper = {
    enable = lib.mkOption {
      type = types.bool;
      default = profile == "desktop";
    };
    package = lib.mkOption {
      type = types.package;
      default = if platform == "non-nixos" then (config.lib.nixGL.wrap pkgs.moxpaper) else pkgs.moxpaper;
    };
  };

  config = {
    services = {
      hyprpaper.enable = lib.mkForce false;
      moxpaper = {
        inherit (cfg) enable;
        inherit (cfg) package;

        settings = {
          power_preference = "high_performance";
          default_transition_type = "random";
          bezier.overshot = [
            0.05
            0.9
            0.1
            1.05
          ];
        };
      };
    };

    nix.settings = lib.mkIf cfg.enable {
      substituters = [ "https://moxpaper.cachix.org" ];
      trusted-substituters = [ "https://moxpaper.cachix.org" ];
      trusted-public-keys = [ "moxpaper.cachix.org-1:zaa2mQr8uPaaqPIUJGza+O3uimu0/KtJmH471q01WwU=" ];
    };
  };
}
