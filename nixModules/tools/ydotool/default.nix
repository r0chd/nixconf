{ conf, lib }:
let inherit (conf) username;
in {
  options.ydotool.enable = lib.mkEnableOption "Enable ydotool";

  config = lib.mkIf conf.ydotool.enable {
    programs.ydotool.enable = true;
    users.users.${username}.extraGroups = [ "ydotool" "uinput" ];
  };
}
