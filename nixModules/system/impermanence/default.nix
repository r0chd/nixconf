{
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  #type = lib.types.listOf (coersedTo str (d: { directory = d; }) rootDir);

  options = {
    impermanence = {
      enable = lib.mkEnableOption "Enable impermanence";
      persist = {
        directories = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };
        files = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
        };
      };
    };
  };

  config = lib.mkIf config.impermanence.enable {
    boot.initrd.postDeviceCommands = lib.mkAfter ''
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

    systemd.tmpfiles.rules =
      [ "d /persist/home 0777 root root -" ]
      ++ (
        builtins.attrNames config.systemUsers
        |> lib.concatMap (user: [ "d /persist/home/${user} 0700 ${user} users -" ])
      );

    fileSystems."/persist".neededForBoot = true;

    programs.fuse.userAllowOther = true;

    environment.persistence."/persist/system" = {
      hideMounts = true;
      directories = config.impermanence.persist.directories;
      files = config.impermanence.persist.files;
    };
  };
}
