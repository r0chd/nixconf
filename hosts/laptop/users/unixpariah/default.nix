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
    atuin_key = { };
  };

  nix.access-tokens = [ config.sops.placeholder.nixos-access-token-github ];

  services = {
    impermanence.enable = true;
    yubikey-touch-detector.enable = true;
  };

  programs = {
    atuin = {
      enable = true;
      settings.key_path = config.sops.secrets.atuin_key.path;
    };

    git = {
      signingKeyFile = "${config.home.homeDirectory}/.ssh/id_yubikey.pub";
      email = "100892812+unixpariah@users.noreply.github.com";
    };
    nixcord.vesktop.enable = true;
    editor = "hx";
    zen-browser.enable = true;
    nix-index.enable = true;
    fastfetch.enable = true;
    starship.enable = true;
    zoxide.enable = true;
    direnv.enable = true;
    seto.enable = true;
    bottom.enable = true;
    keepassxc = {
      enable = true;
      browser-integration.firefox.enable = true;
    };
    multiplexer = {
      enable = true;
      variant = "tmux";
    };
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
    idle.enable = false;
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
    packages = builtins.attrValues {
      inherit (pkgs)
        obsidian
        renderdoc
        zathura
        mpv
        lazygit
        unzip
        gimp3
        imagemagick
        wf-recorder
        libreoffice
        cosmic-files
        ;
    };

    persist = {
      directories = [
        "Games/Nintendo"
        "workspace"
        ".yubico"
      ];
    };
  };
}
