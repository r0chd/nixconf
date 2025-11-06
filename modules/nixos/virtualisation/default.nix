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

  config = {
    virtualisation = {
      libvirtd = {
        onBoot = "ignore";
        onShutdown = "shutdown";
      };
      podman = {
        dockerCompat = true;
        dockerSocket.enable = true;
      };
    };

    users.users = systemUsers
      |> lib.mapAttrs (
        _user: value: {
          extraGroups =
            lib.optionals (value.root.enable && cfg.libvirtd.enable) [ "libvirtd" ]
            ++ lib.optionals (value.root.enable && cfg.docker.enable) [ "docker" ]
            ++ lib.optionals (value.root.enable && cfg.podman.enable) [ "podman" ];
        }
      );

    programs.virt-manager = { inherit (cfg.libvirtd) enable; };
  };
}
