{ lib, pkgs, config, username, std, ... }: {
  options.nh.enable = lib.mkEnableOption "Enable nh";

  config = lib.mkIf config.nh.enable {
    home-manager.users."${username}".programs.nh = {
      enable = true;
      package =
        pkgs.nh.override { nix-output-monitor = pkgs.nix-output-monitor; };
      flake = "${std.dirs.home}/nixconf";
    };
  };
}
