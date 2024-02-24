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

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  programs = {
    git.enable = true;
    fish.enable = true;
    hyprland.enable = true;
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
    extraGroups = ["wheel" "libvirtd"];
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
    cava
    ncspot
    btop
    xdg-desktop-portal-hyprland
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
    gnome3.adwaita-icon-theme
    xclip
    (st.overrideAttrs (oldAttrs: rec {
      src = builtins.fetchTarball {
        url = "https://github.com/unixpariah/st/archive/master.tar.gz";
        sha256 = "0cc9h3sqk2h2m5bcz4jdi5kqj7fx518jchj1crzr9zqdxir2c4gr";
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
