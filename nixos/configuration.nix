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
    users = {
      unixpariah = import ./home.nix;
    };
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Enable doas
  security.doas.enable = true;
  security.sudo.enable = false;
  security.doas.extraRules = [
    {
      users = ["unixpariah"];
      keepEnv = true;
      persist = true;
    }
  ];

  users.users.unixpariah = {
    isNormalUser = true;
    extraGroups = ["wheel" "docker" "libvirtd"];
  };

  programs.fish.enable = true;
  networking.wireless.iwd.enable = true;

  networking.hostName = "nixos";
  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

  programs.hyprland.enable = true;

  sound.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;

  users.defaultUserShell = pkgs.fish;

  environment.systemPackages = with pkgs; [
    qutebrowser

    # Terminal and shell tools
    neovim
    git
    doas
    zoxide
    fzf
    ripgrep
    lsd
    (st.overrideAttrs (oldAttrs: rec {
      src = fetchFromGitHub {
      owner = "unixpariah";
      repo = "st";
      rev = "67e85112ab998c750a621ec041d44bf6a3050f17";
      sha256 = "0s4j999p2y32kh5aw8al6ch7zjn2b31k3slmkbkq3lc3l84i6s68";
    };
    }))

    # System Utilities
    pamixer
    brightnessctl
    grim
    slurp
    iwd
    wget
    unzip
    wl-clipboard
    cava
    ncspot

    # UI
    xdg-desktop-portal-hyprland

    # Programming and Development
    nodejs_21
    gcc
    pkg-config
    gnumake
    home-manager
    openssl
    libxkbcommon
    rustup
    rustfmt
    alejandra

    # Unfree
    discord
  ];

  fonts.packages = with pkgs; [
    jetbrains-mono
    font-awesome
    nerdfonts
  ];

  system.stateVersion = "23.11";
}
