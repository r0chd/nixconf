{username}: {
  environment.shellAliases.cat = "bat";
  home-manager.users."${username}".programs.bat = {
    enable = true;
  };
}
