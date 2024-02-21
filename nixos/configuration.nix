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
    extraGroups = ["wheel"];
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
    fish
    kitty
    tmux
    neovim
    git
    doas
    zoxide
    fzf
    ripgrep
    lsd

    # System Utilities
    pamixer
    brightnessctl
    grim
    slurp
    iwd
    wget
    unzip
    wl-clipboard

    # UI
    waybar
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
