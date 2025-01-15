{ ... }:
{
  programs.nh = {
    #  clean = {
    #    dates = "weekly";
    #    enable = true;
    #    extraArgs = "--keep=3";
    #  };
    flake = "/var/lib/nixconf";
  };
}
