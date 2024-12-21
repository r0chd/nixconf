{
  pkgs,
  lib,
  username,
  shell,
  ...
}:
{
  imports = [
    ./environment
    ./programs
    ./gui
    ./security
    ./network
    ./system
    ./apps
    ../hosts/laptop/users/${username}/configuration.nix
  ];

  options = {
    font = lib.mkOption { type = lib.types.str; };
    email = lib.mkOption { type = lib.types.str; };
  };

  config = {
    programs.home-manager.enable = true;
    home = {
      sessionVariables.HOME_MANAGER_BACKUP_EXT = "bak";
      packages = with pkgs; [
        (writeShellScriptBin "shell" ''
          nix develop "/var/lib/nixconf#devShells.$@.${pkgs.system}" -c ${shell}
        '')
        (writeShellScriptBin "nb" ''
          command "$@" > /dev/null 2>&1 &
          disown
        '')
      ];
      username = username;
      homeDirectory = "/home/${username}";
      stateVersion = "24.11";
    };

    specialisation = {
      Hyprland.configuration = {
        environment.window-manager = {
          enable = true;
          name = "Hyprland";
          backend = "Wayland";
        };
      };
      sway.configuration = {
        environment.window-manager = {
          enable = true;
          name = "sway";
          backend = "Wayland";
        };
      };
      niri.configuration = {
        environment.window-manager = {
          enable = true;
          name = "niri";
          backend = "Wayland";
        };
      };
      i3.configuration = {
        environment.window-manager = {
          enable = true;
          name = "i3";
          backend = "X11";
        };
      };
      gamescope.configuration = {
        environment.window-manager = {
          enable = true;
          name = "gamescope";
          backend = "Wayland";
        };
      };
    };
  };
}
