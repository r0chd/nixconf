{
  pkgs,
  lib,
  config,
  systemUsers,
  inputs,
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
    ./homelab
    ./nixpkgs
    ../theme
  ];

  systemd = {
    enableStrictShellChecks = true;
    services.syslog.enable = false;
    sockets.syslog.enable = false;
  };

  nixpkgs = {
    overlays = import ../overlays inputs config ++ import ../lib config;
    hostPlatform = system;
  };

  environment = {
    defaultPackages = lib.mkDefault [ ];
    systemPackages =
      let
        inherit (pkgs) writeShellScriptBin;
      in
      [
        pkgs.uutils-coreutils-noprefix
        (writeShellScriptBin "mkUser" (builtins.readFile ./mkUser.sh))
        (writeShellScriptBin "mkHost" (builtins.readFile ./mkHost.sh))

        # `nix shell nixpkgs#package` using system nixpkgs
        (writeShellScriptBin "shell" ''
          if [ $# -eq 0 ]; then
            echo "Error: At least one argument (package name) is required"
            echo "Usage: shell <package> [additional-packages...]"
            exit 1
          fi

          args=()
          for pkg in "$@"; do
            args+=("''${NH_FLAKE}#nixosConfigurations.${config.networking.hostName}.pkgs.$pkg")
          done

          nix shell "''${args[@]}"
        '')

        # `nix run nixpkgs#package` using system nixpkgs
        (writeShellScriptBin "run" ''
          if [ $# -eq 0 ]; then
            echo "Error: At least one argument (package name) is required"
            echo "Usage: run <package> [additional-args...]"
            exit 1
          fi

          package="$1"
          shift
          nix run ''${NH_FLAKE}#nixosConfigurations.${config.networking.hostName}.pkgs.$package "$@"
        '')
      ];
    sessionVariables.HOME_MANAGER_BACKUP_EXT = "$(date +%Y%m%d_%H%M%S).bak";
  };

  boot = {
    kernelPackages =
      if config.fileSystems."/".fsType == "zfs" then
        lib.mkDefault pkgs.linuxPackages
      else
        lib.mkDefault pkgs.linuxPackages_latest;
  };

  users = {
    mutableUsers = false;
    users = {
      root = {
        isNormalUser = false;
        #hashedPassword = null;
        password = "test";
      };
    }
    // (
      systemUsers
      |> lib.mapAttrs (
        name: value: {
          isNormalUser = true;
          inherit (value) home;
          hashedPasswordFile = config.sops.secrets."${name}/password".path;
          extraGroups = lib.mkIf value.root.enable [
            "wheel"
          ];
          shell = pkgs.${value.shell};
          createHome = true;
        }
      )
    );
  };
}
