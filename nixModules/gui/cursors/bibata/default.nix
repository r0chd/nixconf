{ config, lib, pkgs, username, ... }: {
  config = lib.mkIf (config.cursor.enable && config.cursor.name == "bibata") {
    environment.systemPackages =
      [ (pkgs.callPackage ./hyprcursor.nix { }) ]; # TODO: Check if on hyprland

    home-manager.users."${username}".gtk.cursorTheme = {
      name = config.cursor.themeName;
      size = config.cursor.size;
      package = pkgs.bibata-cursors;
    };
  };
}
