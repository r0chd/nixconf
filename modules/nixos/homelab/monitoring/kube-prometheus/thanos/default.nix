{ ... }:
{
  imports = [
    ./configmaps.nix
    ./query
    ./query-frontend
    ./store
    ./receive
    ./compact
  ];
}
