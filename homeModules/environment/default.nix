{ system_type, lib, ... }:
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
  ];

  home.persist.directories = lib.mkIf (system_type == "desktop") [
    "Documents"
    "Music"
    "Pictures"
    "Videos"
  ];

}
