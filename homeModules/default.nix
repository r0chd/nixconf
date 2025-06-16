{
  pkgs,
  lib,
  username,
  inputs,
  config,
  hostName,
  system_type,
  ...
}:
{
  imports = [
    ./nix
    ./environment
    ./workspace
    ./programs
    ./security
    ./networking
    ./services
    ../hosts/${hostName}/users/${username}
    ../theme
    ../common/home
  ];

  config = {
    nixpkgs.overlays = import ../overlays inputs config;

    services = {
      udiskie.enable = system_type == "desktop";
      sysnotifier.enable = system_type == "desktop";
    };

    programs = {
      home-manager.enable = true;
    };
    home = {
      persist.directories = [ ".local/state/syncthing" ];
      inherit username;
      packages = with pkgs; [
        (writeShellScriptBin "nb" ''
          command "$@" > /dev/null 2>&1 &
          disown
        '')

        # `nix shell nixpkgs#package` using home manager nixpkgs
        (writeShellScriptBin "shell" ''
          if [ $# -eq 0 ]; then
            echo "Error: At least one argument (package name) is required"
            echo "Usage: shell <package> [additional-args...]"
            exit 1
          fi

          package="$1"
          shift
          nix shell ''${NH_FLAKE}#homeConfigurations.${username}@${hostName}.pkgs.$package "$@"
        '')

        # `nix run nixpkgs#package` using home manager nixpkgs
        (writeShellScriptBin "run" ''
          if [ $# -eq 0 ]; then
            echo "Error: At least one argument (package name) is required"
            echo "Usage: run <package> [additional-args...]"
            exit 1
          fi

          package="$1"
          shift
          nix run ''${NH_FLAKE}#homeConfigurations.${username}@${hostName}.pkgs.$package "$@"
        '')

      ];
      homeDirectory = "/home/${username}";
      stateVersion = "25.11";
    };
  };
}
