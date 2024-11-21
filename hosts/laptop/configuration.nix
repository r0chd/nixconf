{
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    ./disko.nix
    ./gpu.nix
    ./hardware-configuration.nix
  ];

  root = {
    passwordAuthentication = false;
  };

  systemUsers = {
    "unixpariah" = {
      enable = true;
      root.enable = true;
    };
  };
  gc = {
    enable = true;
    interval = 3;
  };
  impermanence = {
    enable = true;
    fileSystem = "btrfs";
    persist = {
      directories = [
        "/var/log"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
      ];
      files = [ ];
    };
  };
  wireless.enable = true;
  power.enable = true;
  bluetooth.enable = true;
  audio.enable = true;
  boot.program = "grub";
  virtualisation.enable = true;
  ydotool.enable = true;
  yubikey = {
    enable = true;
    rootAuth = true;
  };

  zramSwap.enable = true;
  environment = {
    variables.EDITOR = "nvim";
    systemPackages = with pkgs; [
      inputs.nixvim.packages.${system}.default
    ];
  };

  users.users."unixpariah".shell = pkgs.fish;
  programs.fish.enable = true;
  programs.zsh.enable = true;
  security.pam.services.hyprlock = { };

  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  sops.secrets = {
    "ssh_keys/unixpariah" = {
      owner = "unixpariah";
      path = "/persist/home/unixpariah/.ssh/id_ed25519";
    };
    "ssh_keys/unixpariah-yubikey" = {
      owner = "unixpariah";
      path = "/persist/home/unixpariah/.ssh/id_yubikey";
    };
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
  system.stateVersion = "24.11";
}
