{ ... }:
{
  programs.kitty = {
    keybindings = {
      "alt+v" = "paste_from_clipboard";
      "alt+c" = "copy_to_clipboard";
    };
    settings = {
      confirm_os_window_close = 0;
      cursor_trail = 3;
    };
  };
}
