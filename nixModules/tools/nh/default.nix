{
  pkgs,
  username,
}: {
  programs.nh = {
    enable = true;
    flake = "/home/${username}/nixconf";
  };
  environment.systemPackages = with pkgs; [
    nvd
    nix-output-monitor
  ];
}
