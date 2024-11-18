{
  lib,
  pkgs,
  config,
  std,
  ...
}:
{
  options.nh.enable = lib.mkEnableOption "Enable nh";

  config = lib.mkIf config.nh.enable {
    programs.nh = {
      enable = true;
      package = pkgs.nh.override { nix-output-monitor = pkgs.nix-output-monitor; };
      flake = "${std.dirs.home}/nixconf";
    };
  };
}
