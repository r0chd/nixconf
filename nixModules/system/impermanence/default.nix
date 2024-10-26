{ lib, conf, std, inputs }:
let inherit (conf) username impermanence;
in {
  options.impermanence = {
    enable = lib.mkEnableOption "Enable impermanence";
    persist = {
      directories = lib.mkOption {
        type = lib.types.listOf lib.types.string;
        default = [ ];
      };
      files = lib.mkOption {
        type = lib.types.listOf lib.types.string;
        default = [ ];
      };
    };
    persist-home = {
      directories = lib.mkOption {
        type = lib.types.listOf lib.types.string;
        default = [ ];
      };
      files = lib.mkOption {
        type = lib.types.listOf lib.types.string;
        default = [ ];
      };
    };
  };

  config = lib.mkIf conf.impermanence.enable {
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

    systemd.tmpfiles.rules = [
      "d /persist/home 0777 root root -"
      "d ${std.dirs.home-persist} 0700 ${conf.username} users -"
    ];

    fileSystems."/persist".neededForBoot = true;

    programs.fuse.userAllowOther = true;

    home-manager.users."${username}" = {
      imports = [ inputs.impermanence.nixosModules.home-manager.impermanence ];
      home = {
        persistence."${std.dirs.home-persist}" =
          let inherit (impermanence) persist-home;
          in {
            directories = let inherit (persist-home) directories;
            in directories;
            files = let inherit (persist-home) files; in files;
            allowOther = true;
          };
      };
    };

    environment.persistence."/persist/system" =
      let inherit (impermanence) persist;
      in {
        hideMounts = true;
        directories = let inherit (persist) directories; in directories;
        files = let inherit (persist) files; in files;
      };
  };
}
