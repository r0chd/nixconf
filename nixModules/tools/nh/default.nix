{pkgs, ...}: {
  programs.nh = {
    enable = true;
    flake = "/home/unixpariah/nixconf";
  };
  environment.systemPackages = with pkgs; [
    nvd
    nix-output-monitor
  ];
}
