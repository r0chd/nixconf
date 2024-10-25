{ userConfig, pkgs, inputs, lib, config, hostname, arch, ... }:
let
  inherit (userConfig) username colorscheme;
  std = import ./std { inherit username lib hostname; };
  conf = lib.recursiveUpdate (import ./default_config.nix {
    inherit hostname arch lib;
    disableAll = userConfig ? disableAll && userConfig.disableAll == true;
  }) userConfig // {
    colorscheme = import ./colorschemes.nix { inherit colorscheme; };
  };
in {
  imports = [
    (import ./security { inherit conf inputs std pkgs; })
    (import ./gui { inherit conf inputs pkgs lib std; })
    (import ./tools { inherit conf pkgs lib config std inputs; })
    (import ./system { inherit conf pkgs lib std; })
    (import ./hardware { inherit conf lib std; })
    (import ./network { inherit conf pkgs lib std; })
  ];

  nixpkgs.config.allowUnfree = true;

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.postDeviceCommands = lib.mkAfter ''
      mkdir /btrfs_tmp
      mount /dev/root_vg/root /btrfs_tmp
      if [[ -e /btrfs_tmp/root ]]; then
          mkdir -p /btrfs_tmp/old_roots
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
      fi

      delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
      }

      for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
          delete_subvolume_recursively "$i"
      done

      btrfs subvolume create /btrfs_tmp/root
      umount /btrfs_tmp
    '';
  };

  systemd.tmpfiles.rules = [
    "d /persist/home 0777 root root -"
    "d ${std.dirs.home} 0700 ${userConfig.username} users -"
  ];

  fileSystems."/persist".neededForBoot = true;

  programs.fuse.userAllowOther = true;
  home-manager = {
    backupFileExtension = "backup";
    users."${username}" = {
      imports = [ inputs.impermanence.nixosModules.home-manager.impermanence ];
      programs.home-manager.enable = true;
      home = {
        persistence."${std.dirs.home}" = {
          directories = [
            "nixconf"
            ".ssh"
            ".local/share/direnv"
            "workspace"
            "Images"
            "Videos"
            ".cache/nix-index"
            ".config/ruin/images"
            ".cache/zoxide"
          ];
          files = [ ];
          allowOther = true;
        };
        username = "${username}";
        stateVersion = "24.05";
      };
    };
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-users = [ "root" "${username}" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  users = {
    mutableUsers = false;
    users."${userConfig.username}" = {
      isNormalUser = true;
      hashedPasswordFile = config.sops.secrets.password.path;
      extraGroups = [ "wheel" ];
    };
  };

  environment = {
    persistence."/persist/system" = {
      hideMounts = true;
      directories = [
        "/var/log"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/var/lib/iwd"
      ];
      files = [ ];
    };
    systemPackages = with pkgs; [
      (writeShellScriptBin "shell" ''
        nix develop "${std.dirs.config}#devShells.$@.${arch}" -c ${userConfig.shell}
      '')

      (writeShellScriptBin "nb" ''
        command "$@" > /dev/null 2>&1 &
        disown
      '')
    ];
  };

  specialisation = {
    Hyprland.configuration = let
      config.window-manager = {
        enable = true;
        name = "Hyprland";
      };
    in {
      imports =
        [ (import ./environments { inherit config conf inputs pkgs lib; }) ];
      environment.etc."specialisation".text = "Hyprland";
    };
    Sway.configuration = let
      config.window-manager = {
        enable = true;
        name = "sway";
      };
    in {
      imports =
        [ (import ./environments { inherit config conf inputs pkgs lib; }) ];
      environment.etc."specialisation".text = "sway";
    };
    niri.configuration = let
      config.window-manager = {
        enable = true;
        name = "niri";
      };
    in {
      imports =
        [ (import ./environments { inherit config conf inputs pkgs lib; }) ];
      environment.etc."specialisation".text = "niri";
    };
  };
}
