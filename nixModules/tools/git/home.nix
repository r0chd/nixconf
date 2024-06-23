{
  username,
  email,
}: {
  home-manager.users."${username}".programs.git = {
    enable = true;
    userName = "${username}";
    userEmail = "oskar.rochowiak@tutanota.com";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };
}
