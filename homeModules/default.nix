{
  pkgs,
  lib,
  username,
  shell,
  ...
}:
{
  imports = [
    ./gaming
    ./environment
    ./programs
    ./security
    ./network
    ./system
    ./apps
    ../hosts/laptop/users/${username}/configuration.nix
  ];

  options = {
    email = lib.mkOption { type = lib.types.str; };
  };

  config = {
    services.hyprpaper.enable = lib.mkForce false; # TODO: Remove these once wallpaper is optionalized in stylix
    stylix.targets.hyprpaper.enable = lib.mkForce false;

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
      Wayland.configuration = {
        environment.session = "Wayland";
      };
      X11.configuration = {
        environment.session = "X11";
      };
    };
  };
}
