{
  lib,
  config,
  pkgs,
  ...
}:
let
in
{
  systemd.user.services.waybar = {
    Install = {
      WantedBy = [ config.wayland.systemd.target ];
    };

    Unit = {
      Description = "waybar";
      PartOf = [ config.wayland.systemd.target ];
      After = [ config.wayland.systemd.target ];
      ConditionEnvironment = "WAYLAND_DISPLAY";
    };

    Service = {
      ExecStart = "${lib.getExe config.programs.waybar.package}";
      Restart = "always";
      RestartSec = "10";
    };
  };

  home.packages = [ pkgs.playerctl ];
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = import ./nixbar/config.nix { };
    style = import ./nixbar/style.nix { inherit (config) colorscheme; };
  };
}
