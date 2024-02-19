# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [./hardware-configuration.nix];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  security.doas.enable = true;
  security.sudo.enable = false;

  security.doas.extraRules = [{
    users = [ "unixpariah" ];
    keepEnv = true;
    persist = true;  
  }];

  programs.fish.enable = true;

  networking.wireless.iwd.enable = true;

  networking.hostName = "nixos";
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

  programs.hyprland.enable = true;

  sound.enable = true;
  nixpkgs.config.pulseaudio = true;
  hardware.pulseaudio.enable = true;
  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware  = true;

  users.users.unixpariah = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      rustup
    ];
  };

  users.defaultUserShell = pkgs.fish;

  environment.systemPackages = with pkgs; [
    fish
    iwd
    neovim
    kitty
    waybar
    xdg-desktop-portal-hyprland
    qutebrowser
    git
    tmux
    doas
    zoxide
    fzf
    lsd
    ripgrep
    wget
    unzip
    wl-clipboard
    nodejs_21
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
    font-awesome
    nerdfonts
  ];

  system.copySystemConfiguration = true;
  system.stateVersion = "23.11";
}

