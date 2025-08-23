{
  pkgs,
  lib,
  inputs,
  config,
  platform,
  ...
}:
{
  imports = [
    ./nix
    ./nixpkgs
    ./environment
    ./programs
    ./security
    ./networking
    ./services
    ../theme

    inputs.mox-flake.homeManagerModules.moxnotify
    inputs.mox-flake.homeManagerModules.moxpaper
    inputs.mox-flake.homeManagerModules.moxidle
    inputs.mox-flake.homeManagerModules.moxctl
  ];

  xdg.configFile."environment.d/envvars.conf" = lib.mkIf (platform == "non-nixos") {
    text = ''
      PATH="${config.home.homeDirectory}/.nix-profile/bin:$PATH";
    '';
  };

  nixpkgs.overlays = import ../overlays inputs config ++ import ../lib config;

  home = {
    persist.directories = [ ".local/state/syncthing" ];
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
          args+=("''${NH_FLAKE}#homeConfigurations.${config.home.username}@${config.networking.hostName}.pkgs.$pkg")
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
        nix run ''${NH_FLAKE}#homeConfigurations.${config.home.username}@${config.networking.hostName}.pkgs.$package "$@"
      '')
    ];
    stateVersion = "25.11";
  };
}
