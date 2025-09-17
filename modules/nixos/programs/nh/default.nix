_: {
  programs.nh = {
    enable = true;
    flake = "/var/lib/nixconf";
  };
  environment.sessionVariables = {
    NH_BYPASS_ROOT_CHECK = "true";
    #NH_ELEVATION_PROGRAM= "sudo";
    NH_NOTIFY = 1;
  };
}
