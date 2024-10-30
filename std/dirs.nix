{ username, hostname, }: rec {
  home-persist = "/persist/home/${username}";
  home = "/home/${username}";
  config = "${home}/nixconf";
  host = ../hosts/${hostname};
}
