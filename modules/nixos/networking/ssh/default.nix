{ lib, ... }:
{
  services.openssh = {
    enable = true;
    settings = {
      AuthenticationMethods = "publickey";
      PermitRootLogin = "prohibit-password";
    };
  };

  environment.persist.directories = [
    {
      directory = "/root/.ssh";
      user = "root";
      group = "root";
      mode = "u=rwx, g=, o=";
    }
  ];
}
