{
  username,
  hostname,
}: rec {
  home = "/home/${username}";
  config = builtins.getEnv "FLAKE";
  host = "${config}/hosts/${hostname}";
}
