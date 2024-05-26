{username, ...}: {
  home-manager.users."${username}".programs.foot = {
    enable = true;
    settings = {
      main = {
        term = "xterm-256color";
        font = "JetBrainsMono Nerd Font:size=9";
      };
      colors = {
        alpha = 0;
      };
      cursor = {
        color = "111111 dcdccc";
      };
    };
  };
}
