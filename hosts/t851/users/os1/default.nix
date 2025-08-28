{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
{
  nixpkgs.config = {
    allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "slack"
        "obsidian"
      ];
  };

  targets.genericLinux.enable = true;

  programs = {
    obsidian = {
      enable = true;
    };
    atuin.enable = true;
    waybar.enable = lib.mkForce false;

    thunderbird = {
      enable = true;
      profiles = { };
    };
    nh.package = inputs.nh-system.packages.${pkgs.stdenv.hostPlatform.system}.default;
    gnome.enable = true;

    firefox.enable = true;
    chromium.enable = true;

    editor = "hx";
    vcs = {
      signingKeyFile = "${config.home.homeDirectory}/.ssh/id_ed25519";
      identityFile = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];
      email = "os1@qed.ai";
      name = "Oskar Rochowiak";
    };
    multiplexer = {
      enable = true;
      variant = "tmux";
    };
    starship.enable = true;
    zoxide.enable = true;
    direnv.enable = true;
    keepassxc.enable = true;

    ssh.matchBlocks = {
      "gerrit.qed.ai" = {
        host = "gerrit.qed.ai";
        user = config.home.username;
      };
    };

    gcloud = {
      enable = true;
      #authFile = ~/file;
    };
  };

  environment = {
    outputs = {
      "HDMI-A-1" = {
        position = {
          x = 0;
          y = 0;
        };
        refresh = 99.945999;
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

      "eDP-1" = {
        primary = true;
        position = {
          x = 320;
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
    };

    terminal.program = "ghostty";
  };

  stylix = {
    enable = true;
    theme = "catppuccin-mocha";
    cursor.size = 36;
    opacity.terminal = 0.8;
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
        package = pkgs.noto-fonts-emoji-blob-bin;
        name = "Noto Color Emoji";
      };
    };
  };

  services = {
    yubikey-touch-detector.enable = true;
    gc = {
      enable = true;
      interval = 3;
    };
  };

  home.packages = builtins.attrValues {
    inherit (pkgs)
      slack
      signal-desktop
      google-cloud-sql-proxy
      kubectl
      kubernetes-helm
      ;
  };
}
