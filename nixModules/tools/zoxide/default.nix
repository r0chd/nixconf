{
  pkgs,
  username,
  shell,
  ...
}: {
  environment = {
    systemPackages = with pkgs; [
      zoxide
    ];
  };

  environment.shellAliases = {
    cd = "z";
  };

  home-manager.users."${username}".programs.zoxide = {
    enable = true;
    enableZshIntegration = shell == "zsh";
    enableFishIntegration = shell == "fish";
    enableBashIntegration = true;
  };
}
