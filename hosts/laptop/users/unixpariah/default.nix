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
    access-token-github = { };
  };

  nix.access-token-file = config.sops.secrets.access-token-github.path;

  services = {
    impermanence.enable = true;
    yubikey-touch-detector.enable = true;
  };

  programs = {
    atuin = {
      enable = true;
    };

    vcs = {
      signingKeyFile = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      email = "100892812+unixpariah@users.noreply.github.com";
    };
    vesktop.enable = true;
    editor = "hx";
    chromium.enable = true;
    nix-index.enable = true;
    fastfetch.enable = true;
    starship.enable = true;
    zoxide.enable = true;
    direnv.enable = true;
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
      "HDMI-A-1" = {
        position = {
          x = 1920;
          y = 0;
        };
        refresh = 180.0;
        dimensions = {
          width = 2560;
          height = 1440;
        };
        scale = 1.25;
      };
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
    };
    terminal.program = "ghostty";
  };

  stylix = {
    enable = true;
    theme = "gruvbox";
    cursor.size = 36;
    opacity.terminal = 0.8;
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
        package = pkgs.noto-fonts-emoji-blob-bin;
        name = "Noto Color Emoji";
      };
    };
  };

  home = {
    packages = builtins.attrValues {
      inherit (pkgs)
        obsidian
        zathura
        mpv
        lazygit
        unzip
        gimp
        imagemagick
        wf-recorder
        libreoffice
        cosmic-files
        devenv
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
