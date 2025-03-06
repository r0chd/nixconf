{
  pkgs,
  lib,
  username,
  inputs,
  config,
  ...
}:
{
  imports = [
    ./nix
    ./gaming
    ./environment
    ./programs
    ./security
    ./network
    ./services
    ./virtualisation
    ../hosts/laptop/users/${username}/configuration.nix
    inputs.nix-index-database.hmModules.nix-index
  ];

  options.email = lib.mkOption { type = lib.types.str; };

  config = {
    nixpkgs.overlays = import ../overlays inputs config;

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
  };
}
