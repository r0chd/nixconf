{ inputs, pkgs, lib, config, hostname, arch, ... }:
let
  userConfig = {
    arch = arch;
    hostname = hostname;
    email = "oskar.rochowiak@tutanota.com";
    username = "unixpariah";
    statusBar = "waystatus";
    colorscheme = "catppuccin";
    font = "JetBrainsMono Nerd Font";
    terminal = "foot";
    editor = "nvim";
    shell = "fish";
    browser = "qutebrowser";
    cursor = "bibata";
    bootloader = "grub";
    notifications = "mako";
    lockscreen = "hyprlock";
    launcher = "fuzzel";
    power.enable = true;
    boot.loader = "grub";
    boot.legacy = false;
    tmux.enable = true;
    nh.enable = true;
    zoxide.enable = true;
    lsd.enable = true;
    man.enable = true;
    bat.enable = true;
    direnv.enable = true;
    nix-index.enable = true;
    ydotool.enable = true;
    seto.enable = true;
    wireless.enable = true;
    bluetooth.enable = true;
    audio.enable = true;
    virtualisation.enable = true;
    zram.enable = true;
    wallpaper = {
      program = "ruin";
      path = "nix";
    };
    impermanence = {
      enable = true;
      persist = {
        directories = [
          "/var/log"
          "/var/lib/bluetooth"
          "/var/lib/nixos"
          "/var/lib/systemd/coredump"
          "/var/lib/iwd"
        ];
        files = [ ];
      };
      persist-home = {
        directories = [
          "nixconf"
          ".ssh"
          ".local/share/direnv"
          "workspace"
          "Images"
          "Videos"
          ".cache/nix-index"
          ".config/ruin/images"
          ".cache/zoxide"
        ];
        files = [ ];
      };
    };
  };
in {
  imports = [
    (import ../../nixModules {
      inherit userConfig inputs pkgs lib config hostname arch;
    })
    ./disko.nix
    ./gpu.nix
    ./hardware-configuration.nix
  ];

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    zathura
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
  ];

  fonts.packages = with pkgs; [ jetbrains-mono font-awesome nerdfonts ];

  system.stateVersion = "24.05";
}
