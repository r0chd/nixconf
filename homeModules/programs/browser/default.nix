{ config, ... }:
{
  imports = [
    ./firefox
    ./qutebrowser
    ./chromium
    ./ladybird
    ./zen
  ];

  stylix.targets.firefox.profileNames = [ config.home.username ];
}
