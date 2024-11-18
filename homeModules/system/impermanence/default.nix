{
  lib,
  std,
  config,
  ...
}:
{
  options.impermanence = {
    enable = lib.mkEnableOption "Enable home persistance";
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
                method = lib.mkOption {
                  type = types.enum [
                    "bindfs"
                    "symlink"
                  ];
                  default = "bindfs";
                  description = ''
                    The linking method that should be used for this
                    directory. bindfs is the default and works for most use
                    cases, however some programs may behave better with
                    symlinks.
                  '';
                };
              };
            })
          );
        default = [ ];
      };
      files = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };
    };
  };

  config.home.persistence."${std.dirs.home-persist}" = lib.mkIf config.impermanence.enable {
    directories = config.impermanence.persist.directories ++ [ "nixconf" ];
    files = config.impermanence.persist.files;
    allowOther = true;
  };
}
