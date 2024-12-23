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
      Wayland.configuration = {
        environment.session = "Wayland";
      };
      X11.configuration = {
        environment.session = "X11";
      };
    };
  };
}
