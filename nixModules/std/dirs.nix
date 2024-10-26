{ username, hostname, }: rec {
  home-persist = "/persist/home/${username}";
  home = "/home/${username}";
  config = ../..;
  host = "${home}/nixconf/hosts/${hostname}";
}
