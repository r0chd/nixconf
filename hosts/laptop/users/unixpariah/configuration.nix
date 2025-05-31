{
  pkgs,
  lib,
  config,
  ...
}:
{
  nixpkgs.config.allowUnfreePredicate =
    pkgs:
    builtins.elem (lib.getName pkgs) [
      "discord"
      "steam"
      "steam-unwrapped"
      "obsidian"
    ];

  sops.secrets = {
    "yubico/u2f_keys".path = "/home/unixpariah/.config/Yubico/u2f_keys";
    "ssh_keys/id_yubikey".path = "/home/unixpariah/.ssh/id_yubikey";
    nixos-access-token-github = { };
    github-api = { };
    "klocki/jwt_secret" = { };
    "klocki/master_password" = { };
    "klocki/db_password" = { };
  };

  nix.access-tokens = [ config.sops.placeholder.nixos-access-token-github ];

  services = {
    impermanence.enable = true;
    yubikey-touch-detector.enable = true;
  };

  wayland.windowManager = {
    hyprland.enable = false;
    sway.enable = false;
  };

  programs = {
    git = {
      signingKeyFile = "${config.home.homeDirectory}/.ssh/id_yubikey.pub";
      email = "100892812+unixpariah@users.noreply.github.com";
    };
    nixcord.vesktop.enable = true;
    editor = "hx";
    zen.enable = true;
    nix-index.enable = true;
    fastfetch.enable = true;
    fuzzel.enable = true;
    starship.enable = true;
    zoxide.enable = true;
    direnv.enable = true;
    seto.enable = true;
    btop.enable = true;
    keepassxc.enable = true;
    multiplexer = {
      enable = true;
      variant = "tmux";
    };
  };

  gaming = {
    steam.enable = true;
    lutris.enable = true;
    heroic.enable = true;
    bottles.enable = true;
    minecraft.enable = true;
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

    terminal.program = "ghostty";
  };

  stylix = {
    enable = true;
    theme = "gruvbox";
    cursor.size = 36;
    opacity.terminal = 0.4;
    fonts = {
      sizes.terminal = 9;
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.iosevka;
        name = "Iosevka Nerd Font";
      };
      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };

  home = {
    packages = with pkgs; [
      obsidian
      renderdoc
      zathura
      mpv
      lazygit
      brightnessctl
      unzip
      gimp3
      imagemagick
      wf-recorder
      libreoffice
      cosmic-files
    ];

    persist = {
      directories = [
        "Games/Nintendo"
        "workspace"
        "Images"
        "Videos"
        "Documents"
        "Iso"
        ".yubico"
        "wallpapers"
      ];
      files = [ "Passwords.kdbx" ];
    };
  };
}
