{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    inputs.raspberry-pi-nix.nixosModules.raspberry-pi
    inputs.raspberry-pi-nix.nixosModules.sd-image
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  nixpkgs = {
    overlays = [ inputs.nix-minecraft.overlay ];
    config.allowUnfreePredicate = pkgs: builtins.elem (lib.getName pkgs) [ "minecraft-server" ];
  };

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
    bootloader = {
      variant = "none";
      silent = true;
    };
    gc = {
      enable = true;
      interval = 3;
    };
  };

  environment = {
    variables.EDITOR = "hx";
    systemPackages = [ pkgs.helix ];
  };

  networking = {
    wireless.iwd.enable = true;
    firewall.allowedTCPPorts = [
      80
      25565
    ];
  };

  services = {
    httpd = {
      enable = false;
      user = "unixpariah";
      group = "unixpariah";
    };
    tailscale.enable = true;
    postgresql = {
      enable = true;
      ensureDatabases = [ "klocki" ];
      ensureUsers = [
        {
          name = "klocki";
          ensureDBOwnership = true;
        }
      ];
      authentication = lib.mkOverride 10 ''
        # Allow local connections
        local   all   all               trust
        host    all   all   127.0.0.1/32 trust
        host    all   all   ::1/128      trust
      '';
      initialScript = pkgs.writeText "init.sql" ''
        CREATE TABLE IF NOT EXISTS users (
            id SERIAL PRIMARY KEY,
            email VARCHAR(255) UNIQUE NOT NULL CHECK (email ~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'),
            password_hash TEXT NOT NULL,
            is_admin BOOLEAN NOT NULL DEFAULT FALSE,
            created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP
        );
      '';
    };

    traefik = {
      enable = false;

      staticConfigOptions = {
        entryPoints = {
          http = {
            address = ":80";
            forwardedHeaders = {
              trustedIPs = [
                "127.0.0.1/32"
                "10.0.0.0/8"
                "192.168.0.0/16"
              ];
            };
          };
        };
      };

      dynamicConfigOptions = {
        http = {
          routers =
            let
              domain = "app.localhost";
            in
            {
              website-router = {
                entryPoints = [ "http" ];
                rule = "Host(`app.localhost`) || Host(`192.168.30.190`)";
                service = "website";
              };
              auth-router = {
                entryPoints = [ "http" ];
                rule = "Host(`auth.${domain}`)";
                service = "auth";
              };

            };
          services = {
            website.loadBalancer.servers = [ { url = "http://localhost:3000"; } ];
            auth.loadBalancer.servers = [ { url = "http://localhost:8000"; } ];
          };
        };
      };
    };

    prometheus = {
      enable = true;
      scrapeConfigs = [
        {
          job_name = "traefik";
          static_configs = [ { targets = [ "localhost:8082" ]; } ];
        }
      ];
    };

    minecraft-servers = {
      enable = true;
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
