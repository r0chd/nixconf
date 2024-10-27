{ userConfig, pkgs, inputs, lib, config, std, arch, ... }:
let
  inherit (userConfig) username colorscheme;
  conf = userConfig // {
    colorscheme = import ./colorschemes.nix { inherit colorscheme; };
  };
in {
  imports = [
    (import ./security { inherit conf inputs std pkgs lib config; })
    (import ./gui { inherit conf inputs pkgs lib std; })
    (import ./tools { inherit conf pkgs lib std inputs; })
    (import ./system { inherit conf pkgs lib std inputs; })
    (import ./hardware { inherit conf lib pkgs; })
    (import ./network { inherit conf pkgs lib std; })
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  home-manager = {
    backupFileExtension = "backup";
    users."${username}" = {
      programs.home-manager.enable = true;
      home = {
        username = "${username}";
        stateVersion = "24.05";
      };
    };
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-users = [ "root" "${username}" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  users = {
    mutableUsers = false;
    users."${userConfig.username}" = {
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets.password.path;
      extraGroups = [ "wheel" ];
    };
  };

  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "shell" ''
      nix develop "${std.dirs.config}#devShells.$@.${arch}" -c ${userConfig.shell}
    '')

    (writeShellScriptBin "nb" ''
      command "$@" > /dev/null 2>&1 &
      disown
    '')
  ];

  specialisation = {
    Hyprland.configuration = let
      config.window-manager = {
        enable = true;
        name = "Hyprland";
      };
    in {
      imports =
        [ (import ./environments { inherit config conf inputs pkgs lib; }) ];
      environment.etc."specialisation".text = "Hyprland";
    };
    Sway.configuration = let
      config.window-manager = {
        enable = true;
        name = "sway";
      };
    in {
      imports =
        [ (import ./environments { inherit config conf inputs pkgs lib; }) ];
      environment.etc."specialisation".text = "sway";
    };
    niri.configuration = let
      config.window-manager = {
        enable = true;
        name = "niri";
      };
    in {
      imports =
        [ (import ./environments { inherit config conf inputs pkgs lib; }) ];
      environment.etc."specialisation".text = "niri";
    };
  };
}
