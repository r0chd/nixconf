{ ... }:
{
  imports = [
    ./cloudnative-pg.nix
    ./postgres.nix
    ./cert-manager.nix
    ./quickwit.nix
    ./pihole.nix
  ];
}
