{
  pkgs,
  lib,
  config,
  systemUsers,
  hostName,
  inputs,
  profile,
  system,
  ...
}:
{
  imports = [
    ./nix
    ./system
    ./hardware
    ./networking
    ./security
    ./environment
    ./services
    ./documentation
    ./gaming
    ./programs
    ./virtualisation
    ../hosts/${hostName}
    ../theme
    ../common/nixos
  ];

  systemd.enableStrictShellChecks = true;

  nixpkgs = {
    overlays = import ../overlays inputs config;
    hostPlatform = system;
  };

  environment = {
    systemPackages = [
      pkgs.uutils-coreutils-noprefix
      (pkgs.writeShellScriptBin "mkUser" (builtins.readFile ./mkUser.sh))
      (pkgs.writeShellScriptBin "mkHost" (builtins.readFile ./mkHost.sh))

      # `nix shell nixpkgs#package` using system nixpkgs
      (pkgs.writeShellScriptBin "shell" ''
        if [ $# -eq 0 ]; then
          echo "Error: At least one argument (package name) is required"
          echo "Usage: shell <package> [additional-packages...]"
          exit 1
        fi

        args=()
        for pkg in "$@"; do
          args+=("''${NH_FLAKE}#nixosConfigurations.${hostName}.pkgs.$pkg")
        done

        nix shell "''${args[@]}"
      '')

      # `nix run nixpkgs#package` using system nixpkgs
      (pkgs.writeShellScriptBin "run" ''
        if [ $# -eq 0 ]; then
          echo "Error: At least one argument (package name) is required"
          echo "Usage: run <package> [additional-args...]"
          exit 1
        fi

        package="$1"
        shift
        nix run ''${NH_FLAKE}#nixosConfigurations.${hostName}.pkgs.$package "$@"
      '')
    ];
    sessionVariables.HOME_MANAGER_BACKUP_EXT = "$(date +\"%Y%m%d%H%M%S\").bak";
  };

  boot = {
    kernelPackages =
      if config.system.fileSystem == "zfs" then
        lib.mkDefault pkgs.linuxPackages
      else
        lib.mkDefault pkgs.linuxPackages_latest;
  };

  users = {
    mutableUsers = false;
    users =
      {
        root = {
          isNormalUser = false;
          hashedPassword = null;
        };
      }
      // (
        systemUsers
        |> lib.mapAttrs (
          name: value: {
            isNormalUser = true;
            hashedPasswordFile = config.sops.secrets."${name}/password".path;
            extraGroups = lib.mkIf value.root.enable [ "wheel" ];
            shell = pkgs.${value.shell};
            createHome = true;
          }
        )
      );
  };
}
