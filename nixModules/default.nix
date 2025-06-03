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
    ./system
    ./hardware
    ./networking
    ./security
    ./environment
    ./services
    ./documentation
    ./programs
    ../hosts/${hostName}/configuration.nix
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
        deploy-rs.deploy-rs
        uutils-coreutils-noprefix
        (writeShellScriptBin "mkUser" (builtins.readFile ./mkUser.sh))
        (writeShellScriptBin "mkHost" (builtins.readFile ./mkHost.sh))
        (writeShellScriptBin "shell" ''nix shell ''${NH_FLAKE}#nixosConfigurations.${hostname}.pkgs.$1'')
        (writeShellScriptBin "run" ''nix run ''${NH_FLAKE}#nixosConfigurations.${hostname}.pkgs.$1'')
        glib
      ];
      variables.HOME_MANAGER_BACKUP_EXT = "bak";
    };

    boot = {
      kernelPackages =
        if config.system.fileSystem == "zfs" then
          lib.mkDefault pkgs.linuxPackages
        else
          lib.mkDefault pkgs.linuxPackages_latest;
      initrd.systemd.tpm2.enable = lib.mkDefault false;
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
            #hashedPassword = "*";
            initialPassword = "pass";
          };
        }
        // lib.mapAttrs (name: value: {
          isNormalUser = true;
          hashedPasswordFile = config.sops.secrets."${name}/password".path;
          extraGroups = lib.mkIf value.root.enable [ "wheel" ];
          shell = pkgs.${value.shell};
          createHome = true;
        }) systemUsers;
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

    system = {
      #activationScripts.setPermissions = ''
      #setfacl -R -m g:wheel:rwX /var/lib/nixconf
      #find /var/lib/nixconf -type d | xargs setfacl -R -m d:g:wheel:rwX
      #'';
      stateVersion = "25.11";
    };
  };
}
