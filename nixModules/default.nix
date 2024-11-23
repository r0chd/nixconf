{
  pkgs,
  lib,
  config,
  systemUsers,
  ...
}:
{
  imports = [
    ./system
    ./hardware
    ./network
    ./security
    ./environments
  ];

  options = {
    systemUsers = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            enable = lib.mkEnableOption "Enable user";
            root.enable = lib.mkEnableOption "Enable root for user";
            shell = lib.mkOption {
              type = lib.types.enum [
                "bash"
                "zsh"
                "fish"
              ];
              default = "bash";
            };
          };
        }
      );
      default = { };
    };
    gc = {
      enable = lib.mkEnableOption "Garbage collector";
      interval = lib.mkOption {
        type = lib.types.int;
        default = 7;
      };
    };
  };

  config = {
    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

    # Enables all required shells
    programs =
      (builtins.attrValues systemUsers)
      |> builtins.foldl' (
        acc: user:
        acc
        // {
          ${user.shell}.enable = true;
        }
      ) { nano.enable = lib.mkDefault false; };

    users = {
      mutableUsers = false;
      users =
        {
          root = {
            isNormalUser = false;
            hashedPassword = lib.mkIf (!config.root.auth.password) "";
            hashedPasswordFile = lib.mkIf config.root.auth.password config.sops.secrets.password;
          };
        }
        // lib.mapAttrs (name: value: {
          isNormalUser = true;
          hashedPasswordFile = config.sops.secrets.${name}.path;
          extraGroups = lib.mkIf value.root.enable [ "wheel" ];
          shell = pkgs.${value.shell};
        }) systemUsers;
    };

    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operators"
        ];
        auto-optimise-store = true;
        substituters = [ "https://nix-community.cachix.org" ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
        trusted-users = [
          "root"
          "@wheel"
        ];
      };
      gc = lib.mkIf config.gc.enable {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than ${toString config.gc.interval}d";
      };
    };

    specialisation = {
      Hyprland.configuration = {
        window-manager = {
          enable = true;
          name = "Hyprland";
          backend = "Wayland";
        };
        environment.etc."specialisation".text = "Hyprland";
      };
      sway.configuration = {
        window-manager = {
          enable = true;
          name = "sway";
          backend = "Wayland";
        };
        environment.etc."specialisation".text = "sway";
      };
      niri.configuration = {
        window-manager = {
          enable = true;
          name = "niri";
          backend = "Wayland";
        };
        environment.etc."specialisation".text = "niri";
      };
      i3.configuration = {
        window-manager = {
          enable = true;
          name = "i3";
          backend = "X11";
        };
        environment.etc."specialisation".text = "i3";
      };
    };

    system.activationScripts.activateHomeManager = ''
      export PATH=${pkgs.sudo}/bin:${pkgs.nix}/bin:${pkgs.git}/bin:${pkgs.home-manager}/bin:${pkgs.systemd}/bin:${pkgs.gawk}/bin:$PATH

      rm -rf /home/unixpariah/.config/fish

      sudo -u unixpariah nix build "/persist/home/unixpariah/nixconf#homeConfigurations.unixpariah@$(hostname).config.home.activationPackage" --out-link /tmp/nh-homeEBVKhH/result
      sudo -u unixpariah /tmp/nh-homeEBVKhH/result/specialisation/niri/activate test
    '';
  };
}
