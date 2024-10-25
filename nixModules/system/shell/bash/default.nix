{
  pkgs,
  username,
}: {
  users.defaultUserShell = pkgs.bash;
  home-manager.users."${username}".programs.bash = {
    enable = true;
  };
}
