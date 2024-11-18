{ config, lib, ... }:
{
  options.ydotool.enable = lib.mkEnableOption "Enable ydotool";

  config = lib.mkIf config.ydotool.enable {
    programs.ydotool.enable = true;
    users.users = lib.genAttrs (builtins.attrNames config.systemUsers) (user: {
      extraGroups = [
        "ydotool"
        "uinput"
      ];
    });
  };
}
