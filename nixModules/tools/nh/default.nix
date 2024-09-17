{
  pkgs,
  username,
  std,
}: {
  programs.nh = {
    enable = true;
    package = pkgs.nh.override {
      nix-output-monitor = pkgs.nix-output-monitor;
    };
    flake = "${std.dirs.home}/nixconf";
  };
}
