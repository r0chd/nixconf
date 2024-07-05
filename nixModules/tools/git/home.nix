{username}: {
  home-manager.users."${username}".programs.git = {
    enable = true;
    userName = "${username}";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
