{
  pkgs,
  lib,
  config,
  systemUsers,
  hostname,
  inputs,
  system_type,
  ...
}:
{
  imports = [
    ./system
    ./hardware
    ./networking
    ./security
    ./environment
    ./services
    ./documentation
    ./programs
    ../hosts/${hostname}/configuration.nix
    ../theme
  ];

  options.system_type = lib.mkEnableOption "";

  config = {
    nixpkgs.overlays = import ../overlays inputs config;

    environment.systemPackages = with pkgs; [ uutils-coreutils-noprefix ];

    boot = {
      kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
      initrd.systemd.tpm2.enable = lib.mkDefault false;
    };

    programs = {
      fish.enable = lib.mkDefault true;
      zsh.enable = lib.mkDefault true;
      nano.enable = lib.mkDefault false;
    };

    services.udisks2.enable = system_type == "desktop";

    users = {
      mutableUsers = false;
      users =
        {
          root = {
            isNormalUser = false;
            hashedPassword = "*";
          };
        }
        // lib.mapAttrs (name: value: {
          isNormalUser = true;
          hashedPasswordFile = config.sops.secrets."${name}/password".path;
          extraGroups = lib.mkIf value.root.enable [ "wheel" ];
          shell = pkgs.${value.shell};
          createHome = true;
        }) systemUsers;
    };

    nix = {
      channel.enable = false;
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
          "pipe-operators"
        ];
        auto-optimise-store = true;
        substituters = [ "https://cache.garnix.io" ];
        trusted-public-keys = [ "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
        trusted-users = [
          "root"
          "@wheel"
        ];
        allowed-users = [
          "root"
          "@wheel"
        ];
      };
    };

    systemd.services.activate-home-manager = lib.mkIf config.services.impermanence.enable {
      enable = true;
      description = "Activate home manager";
      wantedBy = [ "default.target" ];
      requiredBy = [ "systemd-user-sessions.service" ];
      before = [ "systemd-user-sessions.service" ];
      serviceConfig = {
        Type = "oneshot";
      };
      environment = {
        PATH = lib.mkForce "${pkgs.nix}/bin:${pkgs.git}/bin:${pkgs.home-manager}/bin:${pkgs.sudo}/bin:${pkgs.coreutils}/bin:$PATH";
        NH_FLAKE = "/var/lib/nixconf";
      };
      script = lib.concatMapStrings (user: ''
        if [ ! -L "/persist/home/${user}/.local/state/nix/profiles/home-manager" ]; then
          sudo -u ${user} nh home switch
          continue
        fi
        chown -R ${user}:users /home/${user}/.ssh
        HOME_MANAGER_BACKUP_EXT="bak" sudo -u ${user} /persist/home/${user}/.local/state/nix/profiles/home-manager/activate
      '') (lib.attrNames systemUsers);
    };

    system.stateVersion = "25.05";
  };
}
