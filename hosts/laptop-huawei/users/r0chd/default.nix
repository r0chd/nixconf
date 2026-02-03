{
  lib,
  pkgs,
  config,
  ...
}:
{
  nixpkgs.config.allowUnfreePredicate =
    pkgs:
    builtins.elem (lib.getName pkgs) [
      "slack"
      "obsidian"
      "steam"
      "steam-unwrapped"
    ];

  sops.secrets = {
    "minio/username" = { };
    "minio/password" = { };

    "garage/moxpaper/access_key_id" = { };
    "garage/moxpaper/secret_access_key" = { };

    "garage/flux/access_key_id" = { };
    "garage/flux/secret_access_key" = { };
  };

  programs = {
    zed-editor = {
      enable = true;
      extensions = [ "nix" ];
    };
    irssi = {
      enable = true;
      networks = {
        liberachat = {
          nick = "r0chd";
          server = {
            address = "irc.libera.chat";
            port = 6697;
            autoConnect = true;
          };
          channels = {
            river.autoJoin = true;
          };
        };
      };
    };
    minio-client = {
      enable = true;
      settings = {
        version = "10";
        aliases = {
          tfstate-root = {
            url = "https://s3.minio.r0chd.pl";
            accessKey = config.sops.placeholder."minio/username";
            secretKey = config.sops.placeholder."minio/password";
            api = "s3v4";
            path = "auto";
          };
          moxpaper = {
            url = "https://s3.garage.r0chd.pl";
            accessKey = config.sops.placeholder."garage/moxpaper/access_key_id";
            secretKey = config.sops.placeholder."garage/moxpaper/secret_access_key";
            api = "s3v4";
            path = "auto";
          };
          flux = {
            url = "https://s3.garage.r0chd.pl";
            accessKey = config.sops.placeholder."garage/flux/access_key_id";
            secretKey = config.sops.placeholder."garage/flux/secret_access_key";
            api = "s3v4";
            path = "auto";
          };
        };
      };
    };
    gcloud.enable = true;
    atuin.enable = true;
    vcs = {
      signingKeyFile = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      email = "100892812+unixpariah@users.noreply.github.com";
    };
    editor = "hx";
    multiplexer = {
      enable = true;
      variant = "tmux";
    };
    vesktop.enable = true;
    firefox.enable = true;
    fastfetch.enable = true;
    starship.enable = true;
    zoxide.enable = true;
    direnv.enable = true;
    bottom.enable = true;
    re-toolkit.enable = true;
  };

  environment = {
    terminal.program = "foot";
    outputs = {
      "eDP-1" = {
        position = {
          x = 0;
          y = 1439;
        };
        refresh = 144.0;
        dimensions = {
          width = 1920;
          height = 1080;
        };
      };
      "HDMI-A-1" = {
        position = {
          x = 0;
          y = 0;
        };
        refresh = 180.0;
        dimensions = {
          width = 2560;
          height = 1440;
        };
        scale = 1.25;
      };
    };
  };

  home = {
    persist.directories = [
      "workspace"
      ".yubico"
    ];
    packages = builtins.attrValues {
      inherit (pkgs)
        slack
        obsidian
        devenv
        whydotool
        ;
    };
  };

  services = {
    moxpaper.settings.buckets = {
      moxpaper = {
        url = "https://s3.garage.r0chd.pl";
        access_key_file = config.sops.secrets."garage/moxpaper/access_key_id".path;
        secret_key_file = config.sops.secrets."garage/moxpaper/secret_access_key".path;
        region = "garage";
      };
    };
    moxnotify = {
      valkey.enable = false;
      redis.settings.address = "redis://127.0.0.1:63790";
    };
    impermanence.enable = true;
    yubikey-touch-detector.enable = true;
  };

  stylix = {
    enable = true;
    theme = "catppuccin-mocha";
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
}
