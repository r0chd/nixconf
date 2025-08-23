{ config, ... }:
{
  imports = [
    ./firefox
    ./qutebrowser
    ./chromium
    ./ladybird
  ];

  stylix.targets.firefox.profileNames = [ config.home.username ];
}
