{ conf, lib }:
let inherit (conf) username font;
in {
  config = lib.mkIf (conf.terminal.enable && conf.terminal.program == "kitty") {
    home-manager.users."${username}".programs.kitty = {
      enable = true;
      font.name = "${font}";
      font.size = 9;
      keybindings = {
        "alt+v" = "paste_from_clipboard";
        "alt+c" = "copy_to_clipboard";
      };
      settings = {
        "background_opacity" = 0;
        "confirm_os_window_close" = 0;
      };
    };
  };
}
