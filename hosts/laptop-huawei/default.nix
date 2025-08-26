{
  pkgs,
  config,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  sops.secrets = {
    deploy-rs = {
      owner = "deploy-rs";
      group = "deploy-rs";
      mode = "0440";
    };
  };

  services = {
    sccache.enable = true;
  };

  documentation.enable = true;

  boot.tmp.useTmpfs = true;

  system = {
    bootloader = {
      variant = "limine";
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
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
}
