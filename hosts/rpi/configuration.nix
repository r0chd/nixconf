{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.raspberry-pi-nix.nixosModules.raspberry-pi
    inputs.raspberry-pi-nix.nixosModules.sd-image
  ];

  nixpkgs.config.allowUnfreePredicate = pkgs: builtins.elem (lib.getName pkgs) [ "minecraft-server" ];

  sops.secrets.k3s = { };

  boot.kernelParams = [ "cgroup_enable=memory" ];

  raspberry-pi-nix = {
    board = "bcm2712";
    uboot.enable = false;
    libcamera-overlay.enable = false;
  };

  hardware.raspberry-pi.config = {
    pi5.dt-overlays.vc4-kms-v3d-pi5 = {
      enable = true;
      params = { };
    };
    all.base-dt-params.krnbt = {
      enable = true;
      value = "on";
    };
  };

  system = {
    fileSystem = "ext4";
    bootloader.variant = "none";
    gc = {
      enable = true;
      interval = 3;
    };
  };

  environment = {
    variables.EDITOR = "hx";
    systemPackages = with pkgs; [
      helix
      k3s
      podman-tui
    ];
  };

  networking = {
    wireless.iwd.enable = true;
    firewall.allowedTCPPorts = [
      6443
      25565
    ];
  };

  virtualisation = {
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
    };
  };

  services = {
    k3s = {
      enable = true;
      clusterInit = true;
      role = "server";
    };
    tailscale.enable = true;

    minecraft-servers = {
      enable = false;
      eula = true;

      servers = {
        server1 = {
          enable = true;
          package = pkgs.vanillaServers.vanilla-1_21_5;
          serverProperties = {
            gamemode = "survival";
            difficulty = "hard";
          };
          whitelist = {
            unixpariah = "c2b6e93e-ee38-4d86-b443-1b3069e6f313";
            McKnur = "6551e853-3139-442e-8cc0-fa9fff682e95";
            LiegtAnGomme = "1ec8cc84-1535-460c-86db-910d5dddc0b8";
          };
        };
      };
    };
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
