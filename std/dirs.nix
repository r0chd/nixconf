{ username, hostname, }: rec {
  home = "/home/${username}";
  home-persist = "/persist/${home}";
  config = "${home}/nixconf";
  host = ../hosts/${hostname};
}
