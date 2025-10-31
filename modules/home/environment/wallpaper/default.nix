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
          buckets = {
            moxpaper = {
              url = "http://localhost:3900";
              access_key = "GK8946f79da1abd2f6dc87c24b";
              secret_key = "f87a0e3f32106b8287bdcbda62d2fe33e67b880bed09d02df3d9a4a679388d5d";
              region = "garage";
            };
          };
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
