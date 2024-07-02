{username, ...}: {
  users.users."${username}".openssh.authorizedKeys.keys = [
    (builtins.readFile ./keys/laptop.pub)
  ];
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };
}
