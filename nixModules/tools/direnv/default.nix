{
  username,
  shell,
}: {
  home-manager.users."${username}" = {
    programs = {
      direnv = {
        enable = true;
        nix-direnv.enable = true;
        enableZshIntegration = shell == "zsh";
        #enableFishIntegration = shell == "fish";
        enableBashIntegration = shell != "zsh" && shell != "fish";
      };
    };
  };
}
