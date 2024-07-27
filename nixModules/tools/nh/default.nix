{
  pkgs,
  username,
  std,
}: {
  programs.nh = {
    enable = true;
    flake = "${std.dirs.home}/nixconf";
  };
  environment.systemPackages = with pkgs; [
    nvd
    nix-output-monitor
  ];
}
