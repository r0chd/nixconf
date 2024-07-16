{
  inputs,
  pkgs,
  lib,
  config,
  hostname,
  ...
}: let
  userConfig = {
    username = "unixpariah";
    statusBar = "waystatus";
    colorscheme = "catppuccin";
    font = "JetBrainsMono Nerd Font";
    terminal = "foot";
    editor = "nvim";
    shell = "zsh";
    browser = "firefox";
    power = true;
  };
in {
  imports = [
    (import ../../nixModules/default.nix {inherit userConfig inputs pkgs lib config hostname;})
    #./disko.nix
    ./gpu.nix
    ./hardware-configuration.nix
  ];

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    slurp
    libreoffice
    lazygit
    discord
    brightnessctl
    grim
    unzip
    btop
    vaapi-intel-hybrid
    steam
    gimp
    spotify
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
    font-awesome
    nerdfonts
  ];

  system.stateVersion = "24.05";
}
