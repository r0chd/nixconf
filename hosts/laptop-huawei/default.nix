{
  pkgs,
  lib,
  config,
  systemUsers,
  ...
}:
{
  users.users =
    systemUsers
    |> lib.mapAttrs (
      _user: value: {
        extraGroups = lib.mkIf (
          value.root.enable
          && config.programs.deploy-rs.enable
          && config.programs.deploy-rs.sshKeyFile != null
        ) [ "video" ];
      }
    );

  boot.initrd.kernelModules = [ "amdgpu" ];
  hardware.graphics = {
    enable32Bit = true;
    extraPackages = builtins.attrValues { inherit (pkgs) amdvlk; };
  };

  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  nixpkgs.config.allowUnfreePredicate =
    pkgs:
    builtins.elem (lib.getName pkgs) [
      "nvidia-x11"
      "steam"
      "steam-unwrapped"
    ];

  sops.secrets = {
    k3s = { };
    deploy-rs = {
      owner = "deploy-rs";
      group = "deploy-rs";
      mode = "0440";
    };
  };

  virtualisation = {
    docker.enable = true;
    libvirtd.enable = true;
    buildkitd.enable = true;
  };

  services = {
    sccache.enable = true;
  };

  documentation.enable = true;

  boot.tmp.useTmpfs = true;

  system = {
    bootloader = {
      variant = "systemd-boot";
      silent = true;
    };
    fileSystem = "zfs";
  };

  hardware = {
    power-management.enable = true;
  };

  environment = {
    variables.EDITOR = "hx";
    systemPackages = builtins.attrValues {
      inherit (pkgs)
        helix
        kubectl
        cosmic-icons
        ;
    };
  };

  security = {
    yubikey = {
      enable = true;
      rootAuth = true;
      id = "31888351";
      actions = {
        unplug.enable = true;
        plug.enable = true;
      };
    };
    root.timeout = 0;
  };

  stylix = {
    enable = true;
    theme = "gruvbox";
  };

  programs = {
    deploy-rs.sshKeyFile = config.sops.secrets.deploy-rs.path;
    nix-index.enable = true;
  };

  gaming = {
    steam.enable = true;
    heroic.enable = true;
  };

  networking = {
    wireless = {
      iwd.enable = true;
      mainInterface = "wlan0";
    };
    hostId = "6add04c2";
  };

  services = {
    gc = {
      enable = true;
      interval = 3;
    };
    impermanence.enable = true;

    k3s = {
      tokenFile = config.sops.secrets.k3s.path;
    };
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
