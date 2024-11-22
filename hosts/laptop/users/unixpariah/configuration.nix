{
  pkgs,
  pkgs-stable,
  ...
}:
{
  services.yubikey-touch-detector = {
    enable = true;
  };
  colorscheme.name = "catppuccin";
  editor = "nvim";
  tmux.enable = true;
  zoxide.enable = true;
  lsd.enable = true;
  man.enable = true;
  bat.enable = true;
  direnv.enable = true;
  nix-index.enable = true;
  seto.enable = true;
  btop.enable = true;
  obs.enable = true;
  email = "oskar.rochowiak@tutanota.com";
  font = "JetBrainsMono Nerd Font";
  sops = {
    secrets = {
      nixos-access-token-github = {
        path = "/home/unixpariah/.config/nix/nix.conf";
      };
    };
  };
  home = {
    packages = with pkgs; [
      keepassxc
      zathura
      mpv
      ani-cli
      libreoffice
      lazygit
      vesktop
      brightnessctl
      unzip
      gimp
      spotify
      imagemagick
      pkgs-stable.wf-recorder
      jetbrains-mono
      font-awesome
      nerdfonts
    ];
  };
  impermanence = {
    enable = true;
    persist = {
      directories = [
        "workspace"
        "Images"
        "Videos"
        ".config/vesktop"
        "Documents"
      ];
    };
  };
  gaming = {
    heroic.enable = true;
    steam.enable = true;
    lutris.enable = true;
    minecraft.enable = true;
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
    idle = {
      enable = true;
      program = "swayidle";
      timeout = {
        lock = 300;
        suspend = 1800;
      };
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
}
