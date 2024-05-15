{
  inputs,
  pkgs,
  ...
}: let
  shell = "fish";
  config = {
    shell = "fish"; # Options: fish, zsh, bash
    browser = "firefox"; # Options: firefox, qutebrowser
    zoxide = true;
    bat = true;
    nh = true;
    docs = true;
  };
in {
  imports = [
    (import ../../nixModules/default.nix {inherit config inputs pkgs;})
    ./hardware-configuration.nix
    ../../nixModules/hardware/bootloader/default.nix
    ../../nixModules/hardware/audio/default.nix
    ../../nixModules/hardware/power/default.nix
    ../../nixModules/hardware/nvidia/default.nix
    ../../nixModules/network/default.nix
    ../../nixModules/virtualization/default.nix
    ../../nixModules/security/default.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  home-manager = {
    extraSpecialArgs = {inherit shell;};
    users = {unixpariah = import ../../home/home.nix {inherit shell;};};
  };

  programs = {
    neovim = {
      enable = true;
      vimAlias = true;
    };
    steam.enable = true;
    git.enable = true;
  };

  users = {
    users.unixpariah = {
      isNormalUser = true;
      extraGroups = ["wheel"];
    };
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

  nixpkgs.config.allowUnfree = true;
  hardware.enableAllFirmware = true;

  environment = {
    sessionVariables = {
      XDG_DATA_HOME = "$HOME/.local/share";
      EDITOR = "nvim";
    };
    systemPackages = with pkgs; [
      alejandra
      nil

      ani-cli
      fzf
      ripgrep
      lsd
      brightnessctl
      grim
      slurp
      wget
      unzip
      btop
      discord
      gnome3.adwaita-icon-theme
      libreoffice
      gimp
      vaapi-intel-hybrid
      obsidian
      spotify
    ];
  };

  fonts.packages = with pkgs; [
    jetbrains-mono
    font-awesome
    nerdfonts
  ];

  system.stateVersion = "23.11";
}
