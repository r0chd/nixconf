{ pkgs, conf, lib, username }: {
  config = lib.mkIf (conf.shell == "bash") {
    users.defaultUserShell = pkgs.bash;
    home-manager.users."${username}".programs.bash = { enable = true; };
  };
}
