{
  pkgs,
  lib,
  username,
  inputs,
  config,
  ...
}:
let
  cfg = config.specialisations;
in
{
  imports = [
    ./nix
    ./gaming
    ./environment
    ./programs
    ./security
    ./network
    ./apps
    ./services
    ./virtualisation
    ../hosts/laptop/users/${username}/configuration.nix
    inputs.nix-index-database.hmModules.nix-index
  ];

  options = {
    email = lib.mkOption { type = lib.types.str; };
    specialisations = {
      Wayland.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable Wayland session";
      };
      X11.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable X11 session";
      };
    };
  };

  config = {
    nixpkgs.overlays = import ../overlays inputs config ++ [ inputs.nh.overlays.default ];

    services.hyprpaper.enable = lib.mkForce false; # TODO: Remove these once wallpaper is optionalized in stylix
    stylix.targets.hyprpaper.enable = lib.mkForce false;

    programs.home-manager.enable = true;
    home = {
      inherit username;
      sessionVariables.HOME_MANAGER_BACKUP_EXT = "bak";
      packages = with pkgs; [
        (writeShellScriptBin "nb" ''
          command "$@" > /dev/null 2>&1 &
          disown
        '')
      ];
      homeDirectory = "/home/${username}";
      stateVersion = "25.05";
    };

    specialisation = {
      Wayland.configuration = lib.mkIf cfg.Wayland.enable {
        environment.session = "Wayland";
        xdg.dataFile."home-manager/specialisation".text = "Wayland";
      };
      X11.configuration = lib.mkIf cfg.Wayland.enable {
        environment.session = "X11";
        xdg.dataFile."home-manager/specialisation".text = "X11";
      };
    };
  };
}
