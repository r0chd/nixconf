{
  lib,
  config,
  ...
}:
let
  cfg = config.services.flatpak;
in
{
  config = lib.mkIf cfg.enable {
    # systemd.services.flatpak-repo = {
    #   wantedBy = [ "multi-user.target" ];
    #   path = [ pkgs.flatpak ];
    #   script = ''
    #     flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    #   '';
    # };

    # environment.persist = {
    #   directories = [ "/var/lib/flatpak" ];
    #   users.directories = [
    #     ".var/app"
    #     ".cache/flatpak"
    #     ".local/share/flatpak"
    #   ];
    # };
  };
}
