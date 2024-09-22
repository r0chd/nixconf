{
  inputs,
  pkgs,
  lib,
  config,
  hostname,
  arch,
  ...
}: let
  userConfig = {
    username = "unixpariah";
    statusBar = "waystatus";
    colorscheme = "catppuccin";
    font = "JetBrainsMono Nerd Font";
    terminal = "ghostty";
    editor = "nvim";
    shell = "zsh";
    browser = "firefox";
    cursor = "bibata";
    notifications = "mako";
    lockscreen = "hyprlock";
    launcher = "fuzzel";
    wallpaper = {
      program = "ruin";
      path = "nix";
    };
    ruin = true;
    power = true;
  };
in {
  imports = [
    (import ../../nixModules {inherit userConfig inputs pkgs lib config hostname arch;})
    #./disko.nix
    ./gpu.nix
    ./hardware-configuration.nix
  ];

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    renderdoc
    prismlauncher
    mpv
    ani-cli
    libreoffice
    lazygit
    discord
    brightnessctl
    unzip
    btop
    vaapi-intel-hybrid
    steam
    gimp
    spotify
    imagemagick
    ydotool
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
    font-awesome
    nerdfonts
  ];

  system.stateVersion = "24.05";
}
