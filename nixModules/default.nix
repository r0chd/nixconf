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
    initialPassword = lib.mkOption { type = lib.types.str; };
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
        let
          sops = config.sops;
        in
        {
          root = {
            isNormalUser = false;
            initialPassword = "1234";
            #hashedPasswordFile = lib.mkIf (
            #  sops.enable && sops.managePassword
            #) config.sops.secrets.password.path;
          };
        }
        // lib.mapAttrs (name: value: {
          isNormalUser = true;

          initialPassword = "1234";
          #hashedPasswordFile = config.sops.secrets.${name}.path;
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
