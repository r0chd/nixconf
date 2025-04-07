{
  pkgs,
  lib,
  username,
  inputs,
  config,
  hostname,
  system_type,
  ...
}:
{
  imports = [
    ./nix
    ./gaming
    ./environment
    ./workspace
    ./programs
    ./security
    ./networking
    ./services
    ../hosts/${hostname}/users/${username}/configuration.nix
    ../theme
  ];

  options.email = lib.mkOption { type = lib.types.str; };

  config = {
    nixpkgs.overlays = import ../overlays inputs config;

    services.udiskie.enable = system_type == "desktop";

    programs = {
      home-manager.enable = true;
      nushell.environmentVariables.HOME_MANAGER_BACKUP_EXT = "bak";
    };
    home = {
      inherit username;
      sessionVariables.HOME_MANAGER_BACKUP_EXT = "bak";

      packages = with pkgs; [
        uutils-coreutils-noprefix
        (writeShellScriptBin "nb" ''
          command "$@" > /dev/null 2>&1 &
          disown
        '')
      ];
      homeDirectory = "/home/${username}";
      stateVersion = "25.05";
    };
  };
}
