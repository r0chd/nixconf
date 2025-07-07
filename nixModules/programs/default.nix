{ lib, profile, ... }:
{
  imports = [
    ./nh
    ./git
    ./deploy-rs
  ];

  programs = {
    fish.enable = lib.mkDefault true;
    zsh.enable = lib.mkDefault true;
    nano.enable = lib.mkDefault false;
    #captive-browser = profile == "desktop";
  };
}
