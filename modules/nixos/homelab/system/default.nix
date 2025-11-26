{ ... }:
{
  imports = [
    ./reloader
    ./cloudnative-pg
    ./pihole
    ./zfs-localpv
    ./dragonfly
    ./longhorn
    ./kube-janitor
  ];
}
