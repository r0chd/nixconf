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
    ./network
    ./security
    ./environment
    ./services
    ../hosts/${hostname}/configuration.nix
    inputs.nix-index-database.nixosModules.nix-index
  ];

  options.system_type = lib.mkEnableOption "";

  config = {
    nixpkgs.overlays = import ../overlays inputs config;

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
        substituters = [
          "https://nix-community.cachix.org"
          "https://nixpkgs-wayland.cachix.org"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
        ];
        trusted-users = [ "@wheel" ];
        allowed-users = [ "@wheel" ];
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
