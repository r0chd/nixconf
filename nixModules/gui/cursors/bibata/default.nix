{ conf, lib, pkgs }:
let inherit (conf) username;
in {
  config = lib.mkIf (conf.cursor.enable && conf.cursor.name == "bibata") {
    environment.systemPackages =
      [ (pkgs.callPackage ./hyprcursor.nix { }) ]; # TODO: Check if on hyprland

    home-manager.users."${username}".gtk.cursorTheme = {
      name = conf.cursor.themeName;
      size = conf.cursor.size;
      package = pkgs.bibata-cursors;
    };
  };
}
