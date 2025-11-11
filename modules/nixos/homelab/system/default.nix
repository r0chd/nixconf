{ ... }:
{
  imports = [
    ./reloader
    ./flannel
    ./cloudnative-pg
    ./pihole
    ./zfs-localpv
    #./oauth2-proxy
  ];
}
