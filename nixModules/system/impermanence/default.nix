{ lib, config, std, inputs, username, ... }:
let inherit (config) impermanence;
in {
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  options.impermanence = {
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
    persist-home = {
      directories = lib.mkOption {
        type = with lib.types;
          listOf (either str (submodule {
            options = {
              directory = lib.mkOption {
                type = str;
                default = null;
                description = "The directory path to be linked.";
              };
              method = lib.mkOption {
                type = types.enum [ "bindfs" "symlink" ];
                default = "bindfs";
                description = ''
                  The linking method that should be used for this
                  directory. bindfs is the default and works for most use
                  cases, however some programs may behave better with
                  symlinks.
                '';
              };
            };
          }));
        default = [ ];
      };
      files = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
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

    systemd.tmpfiles.rules = [
      "d /persist/home 0777 root root -"
      "d ${std.dirs.home-persist} 0700 ${username} users -"
    ];

    fileSystems."/persist".neededForBoot = true;

    programs.fuse.userAllowOther = true;

    home-manager.users."${username}" = {
      imports = [ inputs.impermanence.homeManagerModules.default ];
      home.persistence."${std.dirs.home-persist}" =
        let inherit (impermanence) persist-home;
        in {
          directories = let inherit (persist-home) directories;
          in directories ++ [ "nixconf" ];
          files = let inherit (persist-home) files; in files;
          allowOther = true;
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
