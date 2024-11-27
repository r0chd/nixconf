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
    auth = {
      password = false;
      rootPw = true;
    };
    timeout = 0;
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
    unplug = {
      enable = true;
      action = "${pkgs.hyprlock}/bin/hyprlock";
    };
  };

  zramSwap.enable = true;
  environment = {
    variables.EDITOR = "nvim";
    systemPackages = with pkgs; [
      nvd
      nix-output-monitor
      just
      inputs.nixvim.packages.${system}.default
    ];
  };

  security.pam.services.hyprlock = { };

  sops.secrets = {
    "ssh_keys/unixpariah" = {
      owner = "unixpariah";
      path = "/home/unixpariah/.ssh/id_ed25519";
    };
    "ssh_keys/unixpariah-yubikey" = {
      owner = "unixpariah";
      path = "/home/unixpariah/.ssh/id_yubikey";
    };
  };

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";
  system.stateVersion = "24.11";
}
