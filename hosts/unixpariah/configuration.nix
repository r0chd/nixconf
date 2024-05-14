{
  inputs,
  pkgs,
  ...
}: let
  shell = "fish";
in {
  imports = [
    ./hardware-configuration.nix
    ../../nixModules/hardware/bootloader/default.nix
    ../../nixModules/hardware/audio/default.nix
    ../../nixModules/hardware/power/default.nix
    ../../nixModules/network/default.nix
    ../../nixModules/virtualization/default.nix
    ../../nixModules/docs/default.nix
    ../../nixModules/security/default.nix
    ../../nixModules/fonts/default.nix
    ../../nixModules/environments/wayland/default.nix
    ../../nixModules/hardware/nvidia/default.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  home-manager = {
    extraSpecialArgs = {inherit inputs shell;};
    users = {unixpariah = import ../../home/home.nix {inherit shell;};};
  };

  programs = {
    neovim = {
      enable = true;
      vimAlias = true;
    };
    direnv.enable = true;
    steam.enable = true;
    git.enable = true;
    fish.enable = shell == "fish";
    nh = {
      enable = true;
      flake = "/home/unixpariah/nixconf";
    };
  };

  users = {
    defaultUserShell =
      if shell == "fish"
      then pkgs.fish
      else pkgs.zsh;
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
    ani-cli
    qutebrowser
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
    nodePackages_latest.nodejs
    obsidian
    spotify

    nix-output-monitor
    nvd
  ];

  system.stateVersion = "23.11";
}
