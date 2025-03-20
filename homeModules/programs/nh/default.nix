_: {
  programs.nh = {
    enable = true;
    flake = "/var/lib/nixconf";
  };
  programs.nushell.environmentVariables.FLAKE = "/var/lib/nixconf";
}
