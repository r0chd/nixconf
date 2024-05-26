{
  username,
  email,
  ...
}: {
  home-manager.users."${username}".programs.git = {
    enable = true;
    userName = "${username}";
    userEmail = "${email}";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };
}
