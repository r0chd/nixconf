{ ... }:
{
  imports = [
    ./reloader
    ./cloudnative-pg
    ./pihole
    ./zfs-localpv
    ./dragonfly
    #./oauth2-proxy
  ];
}
