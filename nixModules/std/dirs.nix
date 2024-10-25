{ username, hostname, }: rec {
  home = "/persist/home/${username}";
  config = ../..;
  host = "${config}/hosts/${hostname}";
}
