{
  pkgs,
  lib,
  username,
  inputs,
  config,
  ...
}:
{
  # /etc/udev/rules.d/yubikey.rules
  # ACTION=="remove", ENV{SUBSYSTEM}=="usb", ENV{PRODUCT}=="1050/107/571", RUN+="/usr/bin/loginctl lock-sessions"
  #
  # sudo udevadm control --reload-rules

  nixpkgs.config = {
    allowUnfreePredicate = pkgs: builtins.elem (lib.getName pkgs) [ "slack" ];
    nixGLWrap = [
      "niri-unstable"
      "ghostty"
      "zen"
    ];
  };

  targets.genericLinux.enable = true;

  programs = {
    gnome.enable = true;

    zen.enable = true;
    ghostty.settings.window-decoration = lib.mkForce true;
    niri = {
      package = lib.mkForce (config.lib.nixGL.wrap pkgs.niri-unstable);
    };

    editor = "hx";
    git = {
      signingKeyFile = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      identityFile = [ "${config.home.homeDirectory}/.ssh/id_ed25519.pub" ];
      email = "os1@qed.ai";
    };
    multiplexer = {
      enable = true;
      variant = "tmux";
    };
    starship.enable = true;
    zoxide.enable = true;
    direnv.enable = true;
    keepassxc.enable = true;

    ssh = {
      matchBlocks = {
        "gerrit.qed.ai" = {
          host = "gerrit.qed.ai";
          user = username;
        };
      };
    };

    gcloud = {
      enable = true;
      #authFile = ~/file;
    };
  };

  environment = {
    outputs = {
      "eDP-1" = {
        primary = true;
        position = {
          x = 378;
          y = 1440;
        };
        refresh = 60.008;
        dimensions = {
          width = 1920;
          height = 1080;
        };

        monitorSpec = {
          vendor = "CMN";
          product = "0x1409";
          serial = "0x00000000";
        };
      };
      "HDMI-1" = {
        position = {
          x = 0;
          y = 0;
        };
        refresh = 99.946;
        dimensions = {
          width = 2560;
          height = 1440;
        };

        monitorSpec = {
          vendor = "GSM";
          product = "LG IPS QHD";
          serial = "501TFLM09504";
        };
      };
    };

    terminal.program = "ghostty";
    wallpaper.enable = false;
  };

  stylix = {
    enable = true;
    theme = "catppuccin-mocha";
    cursor.size = 36;
    opacity.terminal = 0.4;
    fonts = {
      sizes.terminal = 12;
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

  services.yubikey-touch-detector.enable = true;

  home.packages = with pkgs; [
    git-review
    slack
    signal-desktop
  ];
}
