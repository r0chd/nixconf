{
  pkgs,
  lib,
  username,
  inputs,
  config,
  hostName,
  profile,
  platform,
  ...
}:
{
  imports = [
    ./nix
    ./nixpkgs
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
    xdg.configFile."environment.d/envvars.conf" = lib.mkIf (platform == "non-nixos") {
      text = ''
        PATH="${config.home.homeDirectory}/.nix-profile/bin:$PATH";
      '';
    };

    nixpkgs.overlays = import ../overlays inputs config;

    home = {
      persist.directories = [ ".local/state/syncthing" ];
      inherit username;
      packages = [
        (pkgs.writeShellScriptBin "nb" ''
          command "$@" > /dev/null 2>&1 &
          disown
        '')

        # `nix shell nixpkgs#package` using home manager nixpkgs
        (pkgs.writeShellScriptBin "shell" ''
          if [ $# -eq 0 ]; then
            echo "Error: At least one argument (package name) is required"
            echo "Usage: shell <package> [additional-packages...]"
            exit 1
          fi

          args=()
          for pkg in "$@"; do
            args+=("''${NH_FLAKE}#homeConfigurations.${username}@${hostName}.pkgs.$pkg")
          done

          nix shell "''${args[@]}"
        '')

        # `nix run nixpkgs#package` using home manager nixpkgs
        (pkgs.writeShellScriptBin "run" ''
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
