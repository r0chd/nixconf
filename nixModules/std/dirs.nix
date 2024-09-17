{
  username,
  hostname,
}: rec {
  home = "/home/${username}";
  config = ../..;
  host = "${config}/hosts/${hostname}";
}
