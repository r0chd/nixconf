{
  username,
  shell,
  ...
}: {
  home-manager.users."${username}".programs.zoxide = {
    enable = true;
    enableZshIntegration = shell == "zsh";
    enableFishIntegration = shell == "fish";
    enableBashIntegration = true;
  };
}
