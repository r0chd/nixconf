{ config, lib, username, ... }: {
  options.ydotool.enable = lib.mkEnableOption "Enable ydotool";

  config = lib.mkIf config.ydotool.enable {
    programs.ydotool.enable = true;
    users.users.${username}.extraGroups = [ "ydotool" "uinput" ];
  };
}
