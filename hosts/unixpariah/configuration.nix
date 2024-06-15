{
  inputs,
  pkgs,
  lib,
  ...
}: let
  config = {
    colorscheme = "catppuccin"; # Options: lackluster, catppuccin
    font = "JetBrainsMono Nerd Font";
    terminal = "foot"; # Options: kitty, foot
    editor = "nvim"; # Options: nvim
    shell = "zsh"; # Options: fish, zsh | Default: bash
    browser = "qutebrowser"; # Options: firefox, qutebrowser
    grub = true; # false = systemd-boot, true = grub
    zoxide = true;
    nh = true;
    virtualization = true;
    audio = true;
    wireless = true;
    power = true;
    tmux = true;
    username = "unixpariah";
    hostname = "laptop";
    email = "oskar.rochowiak@tutanota.com";
  };
in {
  imports = [
    (import ../../nixModules/default.nix {inherit config inputs pkgs lib;})
    # ./disko.nix
    ./gpu.nix
    ./hardware-configuration.nix
  ];

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.shellAliases = {
    cat = "bat";
    ls = "lsd";
  };

  environment.systemPackages = with pkgs; [
    libreoffice
    lazygit
    discord
    bat
    lsd
    fzf
    lsd
    brightnessctl
    grim
    wget
    unzip
    btop
    vaapi-intel-hybrid
    spotify
    steam
    gimp
    imagemagick
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
    font-awesome
    nerdfonts
  ];

  system.stateVersion = "23.11";
}
