{
  conf,
  pkgs,
  inputs,
  lib,
  std,
}: {
  imports = [
    (import ./browser {inherit conf inputs pkgs lib;})
    (import ./terminal {inherit conf inputs pkgs;})
    (import ./cursors {inherit conf pkgs lib;})
    (import ./status {inherit conf std pkgs inputs;})
    (import ./notifications {inherit conf;})
    (import ./lockscreen {inherit conf pkgs std;})
    (import ./wallpaper {inherit conf std pkgs inputs;})
    (import ./launcher {inherit conf;})
  ];
}
