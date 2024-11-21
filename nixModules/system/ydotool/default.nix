{ config, lib, ... }:
{
  options.ydotool.enable = lib.mkEnableOption "Enable ydotool";

  config = lib.mkIf config.ydotool.enable {
    programs.ydotool.enable = true;
    users.users = lib.mapAttrs (name: value: {
      extraGroups = lib.mkIf value.root.enable [
        "ydotool"
        "uinput"
      ];
    }) config.systemUsers;
  };
}
