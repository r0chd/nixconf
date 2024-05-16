{username, ...}: {
  programs.git = {
    enable = true;
    userName = "${username}";
    userEmail = "oskar.rochowiak@tutanota.com";
  };
}
