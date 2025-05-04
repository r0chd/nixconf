{
  pkgs,
  lib,
  config,
  systemUsers,
  hostname,
  inputs,
  system_type,
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
    ../hosts/${hostname}/configuration.nix
    ../theme
  ];

  options.system_type = lib.mkEnableOption "";

  config = {
    nixpkgs.overlays = import ../overlays inputs config;

    networking.hosts = {
      "laptop.tail570bfd.ts.net" = [ "laptop" ];
      "iphone-13-pro.tail570bfd.ts.net" = [ "iphone-13-pro" ];
      "laptop-lenovo.tail570bfd.ts.net" = [ "laptop-lenovo" ];
      "rpi.tail570bfd.ts.net" = [ "rpi" ];
      "xiaomi-m2002j9g.tail570bfd.ts.net" = [ "xiaomi-m2002j9g" ];
    };

    environment = {
      systemPackages = with pkgs; [
        uutils-coreutils-noprefix
        (writeShellScriptBin "mkUser" (builtins.readFile ./mkUser.sh))
        (writeShellScriptBin "shell" ''nix shell /var/lib/nixconf#nixosConfigurations.${hostname}.pkgs.$1'')
        (writeShellScriptBin "run" ''nix run /var/lib/nixconf#nixosConfigurations.${hostname}.pkgs.$1'')
        glib
      ];
      variables.HOME_MANAGER_BACKUP_EXT = "bak";
    };

    boot = {
      kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
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
            hashedPassword = "*";
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

    system.stateVersion = "25.05";
  };
}
