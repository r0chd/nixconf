{
  username,
  shell,
  ...
}: {
  home-manager.users."${username}".programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };
}
