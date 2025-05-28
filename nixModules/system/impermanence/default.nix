{
  lib,
  pkgs,
  config,
  inputs,
  systemUsers,
  ...
}:
let
  cfg = config.services.impermanence;
in
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  options = {
    services.impermanence = {
      enable = lib.mkEnableOption "Enable impermanence";
      device = lib.mkOption {
        type = lib.types.str;
        default = "cryptid";
      };
      vg = lib.mkOption { type = lib.types.str; };
    };

    environment.persist = {
      directories = lib.mkOption {
        type =
          with lib.types;
          listOf (
            either str (submodule {
              options = {
                directory = lib.mkOption {
                  type = str;
                  default = null;
                  description = "The directory path to be linked.";
                };
                user = lib.mkOption {
                  type = str;
                  default = null;
                  description = "User owning the directory";
                };
                group = lib.mkOption {
                  type = str;
                  default = null;
                  description = "Group owning the directory";
                };
                mode = lib.mkOption {
                  type = str;
                  default = null;
                  description = "Permissions";
                };
              };
            })
          );
        default = [ ];
      };
      files = lib.mkOption {
        type =
          with lib.types;
          listOf (
            either str (submodule {
              options = {
                file = lib.mkOption {
                  type = str;
                  default = null;
                  description = "The file path to be linked.";
                };
                user = lib.mkOption {
                  type = str;
                  default = "root";
                  description = "User owning the file";
                };
                group = lib.mkOption {
                  type = str;
                  default = "root";
                  description = "Group owning the file";
                };
                mode = lib.mkOption {
                  type = str;
                  default = "0755";
                  description = "Permissions";
                };
              };
            })
          );
        default = [ ];
      };
    };
  };

  config = lib.mkIf cfg.enable {
    #boot.initrd.systemd.services.rollback = {
    #description = "Rollback BTRFS root subvolume";
    #unitConfig.DefaultDependencies = "no";
    #wantedBy = [ "initrd.target" ];
    #after = [ "systemd-cryptsetup@${cfg.device}.service" ];
    #before = [ "sysroot.mount" ];
    #serviceConfig.Type = "oneshot";

    #script = lib.mkIf (config.system.fileSystem == "btrfs") ''
    #vgchange -ay ${cfg.vg}
    #mkdir -p /btrfs_tmp
    #mount /dev/${cfg.vg}/root /btrfs_tmp

    #if [[ -e /btrfs_tmp/root ]]; then
    #mkdir -p /btrfs_tmp/old_roots
    #timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
    #mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    #fi

    #delete_subvolume_recursively() {
    #IFS=$'\n'
    #for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
    #delete_subvolume_recursively "/btrfs_tmp/$i"
    #done
    #btrfs subvolume delete "$1"
    #}

    #for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
    #delete_subvolume_recursively "$i"
    #done

    #btrfs subvolume create /btrfs_tmp/root
    #umount /btrfs_tmp
    #'';
    #};

    boot.initrd.postDeviceCommands = lib.mkIf (config.system.fileSystem == "btrfs") (
      lib.mkAfter ''
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

        for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +${toString config.system.gc.interval}); do
            delete_subvolume_recursively "$i"
        done

        btrfs subvolume create /btrfs_tmp/root
        umount /btrfs_tmp
      ''
    );

    systemd.tmpfiles.rules =
      [ "d /persist/home 0777 root root -" ]
      ++ (
        systemUsers
        |> builtins.attrNames
        |> lib.concatMap (user: [ "d /persist/home/${user} 0700 ${user} users -" ])
      );

    fileSystems = {
      "/persist".neededForBoot = true;
      "/" = lib.mkIf (config.system.fileSystem == "ext4") {
        device = "none";
        fsType = "tmpfs";
        options = [
          "defaults"
          "size=25%"
          "mode=755"
        ];
      };
    };

    programs.fuse.userAllowOther = true;

    environment.persistence."/persist/system" = {
      hideMounts = true;
      directories = [
        "/usr/systemd-placeholder"
        "/var/lib/systemd/coredump"
        "/var/lib/nixos"
        {
          directory = "/var/lib/nixconf";
          user = "root";
          group = "wheel";
          mode = "0775";
        }
      ] ++ config.environment.persist.directories;
      inherit (config.environment.persist) files;
    };

    systemd.services.activate-home-manager = {
      inherit (config.services.impermanence) enable;
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
          chown -R ${user}:users /home/${user}/.ssh
          sudo -u ${user} home-manager switch --flake "/var/lib/nixconf#${user}@${config.networking.hostName}" --no-write-lock-file 
          exit 0
        fi
        chown -R ${user}:users /home/${user}/.ssh
        HOME_MANAGER_BACKUP_EXT="bak" sudo -u ${user} /persist/home/${user}/.local/state/nix/profiles/home-manager/activate
      '') (lib.attrNames systemUsers);
    };
  };
}
