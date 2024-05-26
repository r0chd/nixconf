{
  inputs,
  pkgs,
  ...
}: let
  config = {
    term = "foot"; # Options: kitty, foot
    editor = "nvim"; # Options: nvim
    shell = "fish"; # Options: fish, zsh | Default: bash
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
    (import ../../nixModules/default.nix {inherit config inputs pkgs;})
    ./hardware-configuration.nix
  ];

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.shellAliases = {
    cat = "bat";
    ls = "lsd";
  };

  environment.systemPackages = with pkgs; [
    bat
    lsd
    alejandra
    nil
    ani-cli
    fzf
    ripgrep
    lsd
    brightnessctl
    grim
    slurp
    wget
    unzip
    btop
    discord
    gnome3.adwaita-icon-theme
    libreoffice
    gimp
    vaapi-intel-hybrid
    obsidian
    spotify
    steam
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
    font-awesome
    nerdfonts
  ];

  system.stateVersion = "23.11";
}
