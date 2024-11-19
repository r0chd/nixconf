{
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./system
    ./hardware
    ./network
    ./security
  ];

  options = {
    systemUsers = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            enable = lib.mkEnableOption "Enable user";
            root.enable = lib.mkEnableOption "Enable root for user";
          };
        }
      );
      default = { };
    };
  };

  config = {
    programs.nano.enable = lib.mkDefault false;
    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

    users = {
      mutableUsers = false;
      users =
        {
          root = {
            isNormalUser = false;
            hashedPasswordFile = config.sops.secrets.password.path;
          };
        }
        // lib.mapAttrs (name: value: {
          isNormalUser = true;
          hashedPasswordFile = config.sops.secrets.${name}.path;
          extraGroups = lib.mkIf value.root.enable [ "wheel" ];
        }) config.systemUsers;
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
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 3d";
      };
    };
  };
}
