{ config, lib, username, ... }: {
  config = lib.mkIf (config.shell == "bash") {
    home-manager.users."${username}".programs.bash = { enable = true; };
  };
}
