{ pkgs, ... }: {
  imports = [ ./disko.nix ./gpu.nix ./hardware-configuration.nix ];

  monitors = [
    {
      name = "eDP-1";
      position = {
        x = 0;
        y = 0;
      };
      dimensions = {
        width = 1920;
        height = 1920;
      };
    }
    {
      name = "HDMI-A-1";
      position = {
        x = 1920;
        y = 0;
      };
      dimensions = {
        width = 1920;
        height = 1920;
      };
    }
  ];
  theme = "catppuccin";
  font = "JetBrainsMono Nerd Font";
  email = "oskar.rochowiak@tutanota.com";
  editor = "nvim";
  shell = "fish";
  cursor = {
    enable = true;
    name = "banana";
    themeName = "Banana";
    size = 40;
  };
  statusBar = {
    enable = true;
    program = "waystatus";
  };
  notifications = {
    enable = true;
    program = "mako";
  };
  lockscreen = {
    enable = true;
    program = "hyprlock";
  };
  launcher = {
    enable = true;
    program = "fuzzel";
  };
  power.enable = true;
  terminal = {
    enable = true;
    program = "foot";
  };
  browser = {
    enable = true;
    program = "qutebrowser";
  };
  boot = {
    program = "grub";
    legacy = false;
  };
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
  gaming = {
    heroic.enable = true;
    steam.enable = true;
    lutris.enable = true;
  };
  wallpaper = {
    enable = true;
    program = "ruin";
    path = "nix";
  };
  impermanence = {
    enable = true;
    persist = {
      directories = [ "/var/log" "/var/lib/nixos" "/var/lib/systemd/coredump" ];
      files = [ ];
    };
    persist-home = {
      directories = [
        "workspace"
        "Images"
        "Videos"
        ".config/discord"
        ".local/share/PrismLauncher"
      ];
      files = [ ];
    };
  };

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
    gimp
    spotify
    imagemagick
  ];

  fonts.packages = with pkgs; [ jetbrains-mono font-awesome nerdfonts ];

  system.stateVersion = "24.05";
}
