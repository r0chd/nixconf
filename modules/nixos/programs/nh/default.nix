_: {
  programs.nh = {
    enable = true;
    flake = "/var/lib/nixconf";
  };
  environment.sessionVariables.NH_NOTIFY = 1;
}
