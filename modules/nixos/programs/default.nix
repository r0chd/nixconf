{
  lib,
  ...
}:
{
  imports = [
    ./nh
    ./git
    ./nixos-anywhere
  ];

  programs = {
    less.lessopen = null;
    command-not-found.enable = false;
    fish.enable = lib.mkDefault true;
    zsh.enable = lib.mkDefault true;
    nano.enable = lib.mkDefault false;
  };
}
