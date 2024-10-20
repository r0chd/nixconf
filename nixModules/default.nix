{ userConfig, pkgs, inputs, lib, config, hostname, arch, ... }:
let
  inherit (userConfig) username colorscheme;
  std = import ./std { inherit username lib hostname; };
  conf = lib.recursiveUpdate (import ./default_config.nix {
    inherit hostname arch;
    disableAll = userConfig ? disableAll && userConfig.disableAll == true;
  }) userConfig // {
    colorscheme = import ./colorschemes.nix { inherit colorscheme; };
  };
in {
  imports = [
    (import ./security { inherit conf inputs pkgs std; })
    (import ./gui { inherit conf inputs pkgs lib std; })
    (import ./tools { inherit conf pkgs lib config std inputs; })
    (import ./system { inherit conf pkgs lib std; })
    (import ./hardware { inherit conf lib std; })
    (import ./network { inherit conf pkgs lib std; })
  ];

  nixpkgs.config.allowUnfree = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  home-manager = {
    backupFileExtension = "backup";
    users."${username}" = {
      programs.home-manager.enable = true;
      home = {
        homeDirectory = std.dirs.home;
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
      extraGroups = [ "wheel" "ydotool" ];
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
    Hyprland.configuration = let wm = "Hyprland";
    in {
      imports =
        [ (import ./environments { inherit conf inputs pkgs wm lib; }) ];
      environment.etc."specialisation".text = "Hyprland";
    };
    Sway.configuration = let wm = "sway";
    in {
      imports =
        [ (import ./environments { inherit conf inputs pkgs wm lib; }) ];
      environment.etc."specialisation".text = "Sway";
    };
    niri.configuration = let wm = "niri";
    in {
      imports =
        [ (import ./environments { inherit conf inputs pkgs wm lib; }) ];
      environment.etc."specialisation".text = "niri";
    };
  };
}
