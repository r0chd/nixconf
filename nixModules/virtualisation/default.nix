{
  config,
  lib,
  systemUsers,
  ...
}:
let
  cfg = config.virtualisation;
in
{
  imports = [ ./buildkit ];

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd = {
      onBoot = "ignore";
      onShutdown = "shutdown";
    };

    users.users =
      systemUsers
      |> lib.mapAttrs (
        user: value: {
          extraGroups =
            lib.mkIf value.root.enable [ "libvirtd" ]
            ++ lib.mkIf cfg.docker.enable [ "docker" ]
            ++ lib.mkIf cfg.podman.enable [ "podman" ];
        }
      );

    programs.virt-manager = { inherit (cfg.libvirtd) enable; };
  };
}
