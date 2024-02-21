{pkgs, ...}: {
  programs.kitty = {
    enable = true;
    font.name = "JetBrains Mono";
    keybindings = {
      "alt+v" = "paste_from_clipboard";
      "alt+c" = "copy_to_clipboard";
    };
    settings = {
      "background_opacity" = 0;
      "confirm_os_window_close" = 0;
    };
  };
}
