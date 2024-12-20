{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.virtualisation.distrobox;
in
{
  options.virtualisation.distrobox = {
    enable = lib.mkEnableOption "Enable distrobox";
    images = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            enable = lib.mkEnableOption "Enable image";
            image = lib.mkOption {
              type = lib.types.str;
              example = "archlinux:latest";
            };
          };
        }
      );
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.user.services.ensure-distrobox-images = {
      Unit = {
        Description = "Ensure distrobox images are installed";
      };
      Service = {
        Environment = [
          "PATH=${
            lib.makeBinPath [
              pkgs.coreutils
              pkgs.podman
              pkgs.shadow
            ]
          }"
        ];
        ExecStart = ''
          ${pkgs.distrobox}/bin/distrobox create -n archlinux -I -i archlinux:latest -Y
        '';
      };
      Install.WantedBy = [ "default.target" ];
    };
  };
}
