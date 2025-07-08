{ profile, lib, ... }:
{
  imports = [
    ./wallpaper
    ./compositor
    ./terminal
    ./status-bar
    ./lockscreen
    ./launcher
    ./idle
    ./notify
    ./outputs
  ];

  home.persist.directories = lib.mkIf (profile == "desktop") [
    "Documents"
    "Music"
    "Pictures"
    "Videos"
  ];
}
