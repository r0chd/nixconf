{ lib, pkgs, conf, std, }: {
  options.nh.enable = lib.mkEnableOption "Enable nh";

  config = lib.mkIf conf.nh.enable {
    home-manager.users."${conf.username}".programs.nh = {
      enable = true;
      package =
        pkgs.nh.override { nix-output-monitor = pkgs.nix-output-monitor; };
      flake = "${std.dirs.home}/nixconf";
    };
  };
}
