{
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.config.allowUnfreePredicate =
    pkgs:
    builtins.elem (lib.getName pkgs) [
      "discord"
      "steam"
      "steam-unwrapped"
    ];

  wayland.windowManager.sway.enable = false;

  programs = {
    nix-index.enable = true;
    nh.enable = true;
    fastfetch.enable = true;
    fuzzel.enable = true;
    kitty.enable = true;
    starship.enable = true;
    man.enable = true;
    bat.enable = true;
    zoxide.enable = true;
    lsd.enable = true;
    direnv.enable = true;
    seto.enable = true;
    tmux.enable = true;
    btop.enable = true;
    obs-studio.enable = true;
    nixcord.enable = true;
    browser = {
      enable = true;
      variant = "zen";
    };
    keepassxc = {
      enable = true;
      database.files = [ "Passwords.kdbx" ];
    };
  };

  gaming = {
    steam.enable = true;
    lutris.enable = true;
    heroic.enable = true;
    bottles.enable = true;
    minecraft.enable = true;
  };

  virtualisation.distrobox = {
    enable = true;
    images = {
      archlinux = {
        enable = true;
      };
    };
  };

  sops.secrets."yubico/u2f_keys" = {
    path = "/home/unixpariah/.config/Yubico/u2f_keys";
  };

  environment = {
    outputs = {
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

    statusBar.enable = true;
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
      program = "kitty";
    };
    wallpaper = {
      enable = true;
      program = "ruin";
      path = "nix";
    };
  };

  services = {
    impermanence.enable = true;
    yubikey-touch-detector.enable = true;
  };

  editor = "nvim";
  email = "oskar.rochowiak@tutanota.com";

  stylix = {
    enable = true;
    cursor = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
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
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-dark.yaml";
    polarity = "dark";
  };

  home = {
    packages = with pkgs; [
      zathura
      mpv
      lazygit
      brightnessctl
      unzip
      gimp
      imagemagick
      wf-recorder
      libreoffice
    ];

    persist = {
      directories = [
        "workspace"
        "Images"
        "Videos"
        "Documents"
        "Iso"
      ];
    };
  };
}
