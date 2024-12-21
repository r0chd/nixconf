{
  pkgs,
  pkgs-stable,
  ...
}:
{
  programs = {
    man.enable = true;
    bat.enable = true;
    zoxide.enable = true;
    lsd.enable = true;
    direnv.enable = true;
    nix-index.enable = true;
    seto.enable = true;
    tmux.enable = true;
    btop.enable = true;
    obs-studio.enable = true;
    discord.enable = true;
    browser = {
      enable = true;
      variant = "zen";
    };
    keepassxc = {
      enable = true;
      database.files = [ "Passwords.kdbx" ];
    };
  };

  environment.outputs = {
    "eDP-1" = {
      position = {
        x = 0;
        y = 0;
      };
      refresh = 144.0;
      dimensions = {
        width = 1920;
        height = 1080;
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
        height = 1080;
      };
    };
  };

  virtualisation.distrobox = {
    enable = false;
    images = {
      archlinux = {
        enable = true;
      };
    };
  };

  services.yubikey-touch-detector = {
    enable = true;
  };
  editor = "nvim";
  email = "oskar.rochowiak@tutanota.com";
  font = "JetBrainsMono Nerd Font";
  sops = {
    secrets = {
      aoc-session = { };
      nixos-access-token-github = { };
    };
    # templates."nix.conf" = {
    #   path = "/home/unixpariah/.config/nix/nix.conf";
    #   content = ''
    #     access-tokens = github.com=${config.sops.placeholder.nixos-access-token-github}
    #   '';
    # };
  };

  stylix = {
    enable = true;
    targets.fish.enable = false;
    cursor = {
      name = "Banana";
      package = pkgs.banana-cursor;
      size = 36;
    };
    fonts = {
      sizes = {
        terminal = 9;
      };
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
    };
    opacity = {
      terminal = 0.0;
    };
    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/refs/heads/master/wallpapers/nixos-wallpaper-catppuccin-mocha.png";
      sha256 = "7e6285630da06006058cebf896bf089173ed65f135fbcf32290e2f8c471ac75b";
    };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";
    polarity = "dark";
  };

  home.packages = with pkgs; [
    zathura
    mpv
    ani-cli
    libreoffice
    lazygit
    brightnessctl
    unzip
    gimp
    spotify
    imagemagick
    pkgs-stable.wf-recorder
  ];

  impermanence = {
    enable = true;
    persist = {
      directories = [
        "workspace"
        "Images"
        "Videos"
        "Documents"
      ];
    };
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
  wallpaper = {
    enable = true;
    program = "ruin";
    path = "nix";
  };

}
