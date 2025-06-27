{
  pkgs,
  lib,
  config,
  systemUsers,
  hostName,
  inputs,
  system_type,
  arch,
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
    ../hosts/${hostName}
    ../theme
    ../common/nixos
  ];

  options.system_type = lib.mkEnableOption "";

  config = {
    nixpkgs = {
      overlays = import ../overlays inputs config;
      hostPlatform = arch;
    };

    networking = { inherit hostName; };

    environment = {
      systemPackages = with pkgs; [
        uutils-coreutils-noprefix
        (writeShellScriptBin "mkUser" (builtins.readFile ./mkUser.sh))
        (writeShellScriptBin "mkHost" (builtins.readFile ./mkHost.sh))

        # `nix shell nixpkgs#package` using system nixpkgs
        (writeShellScriptBin "shell" ''
          if [ $# -eq 0 ]; then
            echo "Error: At least one argument (package name) is required"
            echo "Usage: shell <package> [additional-args...]"
            exit 1
          fi

          package="$1"
          shift
          nix shell ''${NH_FLAKE}#nixosConfigurations.${hostName}.pkgs.$package
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
          nix run ''${NH_FLAKE}#nixosConfigurations.${hostName}.pkgs.$package "$@"
        '')
      ];
      sessionVariables.HOME_MANAGER_BACKUP_EXT = "$(date +\"%Y%m%d%H%M%S\").bak";
      variables.HOME_MANAGER_BACKUP_EXT = "$(date +\"%Y%m%d%H%M%S\").bak";
    };

    boot = {
      kernelPackages =
        if config.system.fileSystem == "zfs" then
          lib.mkDefault pkgs.linuxPackages
        else
          lib.mkDefault pkgs.linuxPackages_latest;
    };

    programs = {
      fish.enable = lib.mkDefault true;
      zsh.enable = lib.mkDefault true;
      nano.enable = lib.mkDefault false;
    };

    services = {
      udisks2.enable = system_type == "desktop";
      gnome.gnome-keyring.enable = system_type == "desktop";
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

    # Fully disable channels
    nix = {
      channel.enable = false;
      registry = (lib.mapAttrs (_: flake: { inherit flake; }) inputs);
      nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") inputs;
      settings = {
        nix-path = lib.mapAttrsToList (n: _: "${n}=flake:${n}") inputs;
        flake-registry = "";
      };
    };

    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operators"
        ];
        auto-optimise-store = true;
        substituters = [ "https://cache.garnix.io" ];
        trusted-public-keys = [ "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
        trusted-users = [
          "root"
          "@wheel"
        ];
        allowed-users = [
          "root"
          "@wheel"
        ];
      };
    };

    system.stateVersion = "25.11";
  };
}
