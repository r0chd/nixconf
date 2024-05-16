{username, ...}: {
  home-manager.users."${username}".programs.bash = {
    enable = true;
  };
}
