{
  pkgs,
  username,
  helpers,
}: {
  programs.nh = {
    enable = true;
    flake = "${helpers.home}/nixconf";
  };
  environment.systemPackages = with pkgs; [
    nvd
    nix-output-monitor
  ];
}
