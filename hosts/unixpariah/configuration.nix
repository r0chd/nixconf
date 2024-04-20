{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../nixModules/hardware/nvidia/default.nix
    ../../nixModules/hardware/bootloader/default.nix
    ../../nixModules/hardware/audio/default.nix
    ../../nixModules/hardware/power/default.nix
    ../../nixModules/network/default.nix
    ../../nixModules/virtualization/default.nix
    ../../nixModules/docs/default.nix
    ../../nixModules/security/default.nix
    ../../nixModules/fonts/default.nix
    ../../wayland/configuration.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users = {unixpariah = import ../../home/home.nix;};
  };

  programs = {
    direnv.enable = true;
    steam.enable = true;
    git.enable = true;
    fish.enable = true;
  };

  users = {
    defaultUserShell = pkgs.fish;
    users.unixpariah = {
      isNormalUser = true;
      extraGroups = ["wheel" "libvirtd"];
    };
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

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
    libreoffice
    gimp
    kitty
    vaapi-intel-hybrid
    nil
  ];

  system.stateVersion = "23.11";
}
