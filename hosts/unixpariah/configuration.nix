{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: let
  userConfig = {
    colorscheme = "catppuccin"; # Options: catppuccin
    font = "JetBrainsMono Nerd Font";
    terminal = "foot"; # Options: kitty, foot
    editor = "nvim"; # Options: nvim
    shell = "zsh"; # Options: fish, zsh | Default: bash
    browser = "qutebrowser"; # Options: firefox, qutebrowser, chromium
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
  };
in {
  imports = [
    (import ../../nixModules/default.nix {inherit userConfig inputs pkgs lib config;})
    # ./disko.nix
    ./gpu.nix
    ./hardware-configuration.nix
  ];

  sops.secrets = {
    password = {};
    ssh-pk = {};
  };

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
    brightnessctl
    grim
    unzip
    btop
    vaapi-intel-hybrid
    spotify
    steam
    gimp
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
    font-awesome
    nerdfonts
  ];

  system.stateVersion = "23.11";
}
