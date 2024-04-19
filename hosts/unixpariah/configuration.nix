{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {unixpariah = import ./home.nix;};
  };

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:0:1:0";
    };
  };

  virtualisation.libvirtd.enable = true;
  programs = {
    direnv.enable = true;
    steam.enable = true;
    virt-manager.enable = true;
    git.enable = true;
    fish.enable = true;
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  documentation.dev.enable = true;

  security = {
    doas = {
      enable = true;
      extraRules = [
        {
          users = ["unixpariah"];
          keepEnv = true;
          persist = true;
        }
      ];
    };
    sudo.enable = false;
    rtkit.enable = true;
  };

  users = {
    defaultUserShell = pkgs.fish;
    users.unixpariah = {
      isNormalUser = true;
      extraGroups = ["wheel" "libvirtd"];
    };
  };

  networking = {
    wireless.iwd.enable = true;
    hostName = "nixos";
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

  sound.enable = true;
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;
  environment.sessionVariables = {
    EDITOR = "nvim";
  };
  environment.systemPackages = with pkgs; [
    qutebrowser
    neovim
    bat
    zoxide
    fzf
    ripgrep
    lsd
    pamixer
    brightnessctl
    grim
    slurp
    wget
    unzip
    cava
    spotify
    btop
    gnumake
    home-manager
    alejandra
    discord
    gnome3.adwaita-icon-theme
    man-pages
    man-pages-posix
    libreoffice
    gimp
    pavucontrol
    wirelesstools
    kitty
    vaapi-intel-hybrid
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
    font-awesome
    nerdfonts
  ];

  system.stateVersion = "23.11";
}
