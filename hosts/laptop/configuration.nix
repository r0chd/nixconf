{ username, pkgs, pkgs-stable, std, ... }: {
  imports = [ ./disko.nix ./gpu.nix ./hardware-configuration.nix ];

  security.pam.services.hyprlock = { };
  impermanence = {
    enable = true;
    persist = {
      directories = [ "/var/log" "/var/lib/nixos" "/var/lib/systemd/coredump" ];
      files = [ ];
    };
  };
  wireless.enable = true;
  power.enable = true;
  bluetooth.enable = true;
  audio.enable = true;
  boot.program = "grub";
  virtualisation.enable = true;
  zram.enable = true;
  systemUsers = {
    "unixpariah" = {
      enable = true;
      root.enable = true;
    };
  };
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

  # Here begins the home modules

  home-manager.users.${username} = {
    font = "JetBrainsMono Nerd Font";
    home = {
      packages = with pkgs; [
        zathura
        mpv
        ani-cli
        libreoffice
        lazygit
        discord
        brightnessctl
        unzip
        gimp
        spotify
        imagemagick
        pkgs-stable.wf-recorder
      ];
    };
    impermanence.persist = {
      directories =
        [ "workspace" "Images" "Videos" ".config/discord" "Documents" ];
      files = [ ];
    };
    gaming = {
      heroic.enable = true;
      steam.enable = true;
      lutris.enable = true;
      minecraft.enable = true;
    };
    sops = {
      secrets.nixos-access-token-github = {
        path = "${std.dirs.home}/.config/nix/nix.conf";
      };
    };

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
    screenIdle = {
      lockscreen = {
        enable = true;
        program = "hyprlock";
      };
    };
    launcher = {
      enable = true;
      program = "fuzzel";
    };
    terminal = {
      enable = true;
      program = "foot";
    };
    browser = {
      enable = true;
      program = "zen";
    };
    wallpaper = {
      enable = true;
      program = "ruin";
      path = "nix";
    };
  };

  screenIdle = {
    idle = {
      enable = true;
      program = "swayidle";
      timeout = {
        lock = 300;
        suspend = 1800;
      };
    };
  };

  outputs = {
    "eDP-1" = {
      position = {
        x = 0;
        y = 0;
      };
      refresh = 144.0;
      dimensions = {
        width = 1920;
        height = 1920;
      };
    };
    "HDMI-A-1" = {
      position = {
        x = 1920;
        y = 0;
      };
      refresh = 60.0;
      dimensions = {
        width = 1920;
        height = 1920;
      };
    };
  };

  sops = {
    enable = true;
    managePassword = true;
  };
  colorscheme.name = "catppuccin";
  font = "JetBrainsMono Nerd Font";
  email = "oskar.rochowiak@tutanota.com";
  editor = "nvim";
  shell = "fish";

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
  btop.enable = true;
  obs.enable = true;
  fonts.packages = with pkgs; [ jetbrains-mono font-awesome nerdfonts ];

  system.stateVersion = "24.11";
}
