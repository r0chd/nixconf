{ pkgs, config, lib, username, ... }: {
  config = lib.mkIf (config.shell == "bash") {
    users.defaultUserShell = pkgs.bash;
    home-manager.users."${username}".programs.bash = { enable = true; };
  };
}
