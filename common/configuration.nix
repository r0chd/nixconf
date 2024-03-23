{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {unixpariah = import ./home.nix;};
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

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
    grim
    slurp
    iwd
    wget
    unzip
    cava
    ncspot
    btop
    gnumake
    home-manager
    rustup
    alejandra
    discord
    nodejs_21
    rnix-lsp
    gnome3.adwaita-icon-theme
    nodePackages.pnpm
    nodePackages_latest.typescript-language-server
    nodePackages_latest.vscode-html-languageserver-bin
    man-pages
    steam
    man-pages-posix
    zig
    zls
    prettierd
    libreoffice
    fd
    gimp
    firefox
    pavucontrol
    mpv
    wirelesstools
    kitty
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
    font-awesome
    nerdfonts
  ];

  system = {
    autoUpgrade = {
      enable = true;
      flake = inputs.self.outPath;
      flags = [
        "--update-inpit"
        "nixpkgs"
        "-L"
      ];
      dates = "09:00";
      randomizedDelaySec = "45min";
    };
    stateVersion = "23.11";
  };
}
