{
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.services.impermanence;
in
{
  imports = [ inputs.impermanence.homeManagerModules.impermanence ];

  options = {
    services.impermanence.enable = lib.mkEnableOption "impermanence";
    home.persist = {
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

  config = lib.mkIf config.services.impermanence.enable {
    home.persistence."/persist${config.home.homeDirectory}" = {
      directories = [
        ".local/state/nix/profiles"
        ".cache/nix-index"
      ] ++ config.home.persist.directories;
      inherit (config.home.persist) files;
      allowOther = true;
    };
  };
}
