{
  config,
  lib,
  systemUsers,
  ...
}:
let
  cfg = config.system.ydotool;
in
{
  options.system.ydotool.enable = lib.mkEnableOption "Enable ydotool";

  config = lib.mkIf cfg.enable {
    programs.ydotool.enable = true;
    users.users = lib.mapAttrs (name: value: {
      extraGroups = lib.mkIf value.root.enable [
        "ydotool"
        "uinput"
      ];
    }) systemUsers;
  };
}
