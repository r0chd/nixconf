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
      mountPoint = lib.mkOption {
        type = lib.types.str;
        default = "/persist";
      };
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
    boot.initrd = {
      systemd.services = {
        btrfs-rollback = lib.mkIf (config.system.fileSystem == "btrfs") {
          description = "Rollback BTRFS root subvolume to a pristine state";
          wantedBy = [ "initrd.target" ];
          after = [ "systemd-cryptsetup@crypted-main.service" ];
          before = [ "sysroot.mount" ];
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          script = ''
            mkdir -p /mnt
            # We first mount the btrfs root to /mnt
            # so we can manipulate btrfs subvolumes.
            mount -o subvol=/ /dev/mapper/crypted-main /mnt
            # While we're tempted to just delete /root and create
            # a new snapshot from /root-blank, /root is already
            # populated at this point with a number of subvolumes,
            # which makes `btrfs subvolume delete` fail.
            # So, we remove them first.
            #
            # /root contains subvolumes:
            # - /root/var/lib/portables
            # - /root/var/lib/machines
            #
            # I suspect these are related to systemd-nspawn, but
            # since I don't use it I'm not 100% sure.
            # Anyhow, deleting these subvolumes hasn't resulted
            # in any issues so far, except for fairly
            # benign-looking errors from systemd-tmpfiles.
            btrfs subvolume list -o /mnt/root |
              cut -f9 -d' ' |
              while read subvolume; do
                echo "deleting /$subvolume subvolume..."
                btrfs subvolume delete "/mnt/$subvolume"
              done &&
              echo "deleting /root subvolume..." &&
              btrfs subvolume delete /mnt/root
            echo "restoring blank /root subvolume..."
            btrfs subvolume snapshot /mnt/root-blank /mnt/root
            # Once we're done rolling back to a blank snapshot,
            # we can unmount /mnt and continue on the boot process.
            umount /mnt
          '';
        };

        zfs-rollback = lib.mkIf (config.system.fileSystem == "zfs") {
          description = "Rollback ZFS datasets to a pristine state";
          wantedBy = [ "initrd.target" ];
          after = [ "zfs-import-zroot.service" ];
          before = [ "sysroot.mount" ];
          path = [ pkgs.zfs ];
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          script = ''
            zfs rollback -r zroot/local/root@blank
          '';
        };
      };
    };

    systemd.tmpfiles.rules =
      [ "d ${cfg.mountPoint}/home 0777 root root -" ]
      ++ (
        systemUsers
        |> builtins.attrNames
        |> lib.concatMap (user: [ "d ${cfg.mountPoint}/home/${user} 0700 ${user} users -" ])
      );

    fileSystems = {
      "${cfg.mountPoint}".neededForBoot = true;
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

    environment.persistence."${cfg.mountPoint}/system" = {
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
      environment.PATH = lib.mkForce "${pkgs.nix}/bin:${pkgs.git}/bin:${pkgs.home-manager}/bin:${pkgs.sudo}/bin:${pkgs.coreutils}/bin:$PATH";
      script = lib.concatMapStrings (user: ''
        chown -R root:wheel /var/lib/nixconf
        chmod -R 775 /var/lib/nixconf

        chown -R ${user}:users /home/${user}/.ssh
        if [ ! -L "${cfg.mountPoint}/home/${user}/.local/state/nix/profiles/home-manager" ]; then
          HOME_MANAGER_BACKUP_EXT="bak" sudo -u ${user} home-manager switch --flake "/var/lib/nixconf#${user}@${config.networking.hostName}" --no-write-lock-file 
          exit 0
        fi
        HOME_MANAGER_BACKUP_EXT="bak" sudo -u ${user} ${cfg.mountPoint}/home/${user}/.local/state/nix/profiles/home-manager/activate
      '') (lib.attrNames systemUsers);
    };
  };
}
