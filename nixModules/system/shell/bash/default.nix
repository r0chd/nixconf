{ pkgs, conf, lib, }:
let inherit (conf) username;
in {
  config = lib.mkIf (conf.shell == "bash") {
    users.defaultUserShell = pkgs.bash;
    home-manager.users."${username}".programs.bash = { enable = true; };
  };
}
