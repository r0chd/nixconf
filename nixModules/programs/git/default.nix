_: {
  programs.git = {
    enable = true;
    config.safe.directory = [ "/var/lib/nixconf" ];
  };
}
