{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {unixpariah = import ./home.nix;};
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];
  services.xserver = {
    enable = true;
    xkb.layout = "us";
    videoDrivers = ["intel"];

    desktopManager.xterm.enable = false;
    displayManager = {
      lightdm.enable = true;
      setupCommands = ''
        ${pkgs.xorg.xrandr}/bin/xrandr --output eDP1 --primary --auto --output HDMI1 --left-of eDP1 --auto
      '';
      autoLogin = {
        enable = true;
        user = "titus";
      };
    };
    displayManager.defaultSession = "none+dwm";
    windowManager.dwm.enable = true;

    libinput = {
      enable = true;
      mouse = {
        accelProfile = "flat";
      };
      touchpad = {
        accelProfile = "flat";
      };
    };
  };

  programs = {
    git.enable = true;
    fish.enable = true;
  };

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  security = {
    doas.enable = true;
    sudo.enable = false;
    doas.extraRules = [
      {
        users = ["unixpariah"];
        keepEnv = true;
        persist = true;
      }
    ];
  };

  users.users.unixpariah = {
    isNormalUser = true;
    extraGroups = ["wheel"];
  };

  networking = {
    wireless.iwd.enable = true;
    hostName = "nixos";
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

  sound.enable = true;
  security.rtkit.enable = true;

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

  users.defaultUserShell = pkgs.fish;

  environment.systemPackages = with pkgs; [
    qutebrowser
    neovim
    git
    doas
    zoxide
    fzf
    ripgrep
    lsd
    pamixer
    brightnessctl
    lua-language-server
    grim
    slurp
    iwd
    wget
    unzip
    wl-clipboard
    cava
    ncspot
    btop
    pkg-config
    gnumake
    home-manager
    rustup
    rustfmt
    stylua
    alejandra
    discord
    nodejs_21
    rustup
    rnix-lsp
    xorg.libX11
    xorg.libX11.dev
    xorg.libxcb
    xorg.libXft
    xorg.libXinerama
    xorg.xinit
    xorg.xinput
    #xorg.
    (st.overrideAttrs (oldAttrs: rec {
      src = builtins.fetchTarball {
        url = "https://github.com/unixpariah/st/archive/master.tar.gz";
        sha256 = "0cc9h3sqk2h2m5bcz4jdi5kqj7fx518jchj1crzr9zqdxir2c4gr";
      };
      buildInputs = oldAttrs.buildInputs ++ [harfbuzz];
    }))
    (dwm.overrideAttrs (oldAttrs: rec {
      src = builtins.fetchTarball {
        url = "https://github.com/unixpariah/dwm/archive/master.tar.gz";
        sha256 = "0xb0lrh6003fjljvdcpfv5bvxqpb6kqzjk3sy6yrhia2xf2irrs4";
      };
      buildInputs = oldAttrs.buildInputs ++ [harfbuzz];
    }))
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
    font-awesome
    nerdfonts
  ];

  system.stateVersion = "23.11";
}
