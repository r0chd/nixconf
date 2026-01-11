{
  lib,
  ...
}:
{
  imports = [
    ./nh
    ./git
  ];

  programs = {
    less.lessopen = null;
    command-not-found.enable = false;
    fish.enable = lib.mkDefault true;
    zsh.enable = lib.mkDefault true;
    nano.enable = lib.mkDefault false;
  };
}
