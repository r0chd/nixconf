{
  lib,
  config,
  inputs,
  systemUsers,
  ...
}:
let
  cfg = config.system.impermanence;
in
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  options.system = {
    impermanence = {
      enable = lib.mkEnableOption "Enable impermanence";
      persist = {
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
  };

  config = lib.mkIf cfg.enable {
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
        builtins.attrNames systemUsers
        |> lib.concatMap (user: [ "d /persist/home/${user} 0700 ${user} users -" ])
      );

    fileSystems."/persist".neededForBoot = true;

    programs.fuse.userAllowOther = true;

    environment.persistence."/persist/system" = {
      hideMounts = true;
      directories = [
        {
          directory = "/var/lib/nixconf";
          user = "root";
          group = "wheel";
          mode = "0664";
        }
      ] ++ cfg.persist.directories;
      files = cfg.persist.files;
    };
  };
}
