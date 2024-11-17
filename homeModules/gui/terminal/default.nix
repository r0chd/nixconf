{ lib, ... }: {
  options = {
    terminal = {
      enable = lib.mkEnableOption "Enable terminal emulator";
      program =
        lib.mkOption { type = lib.types.enum [ "kitty" "foot" "ghostty" ]; };
    };
  };

  imports = [ ./kitty ./foot ./ghostty ];
}
