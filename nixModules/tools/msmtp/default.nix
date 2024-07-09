{
  config,
  email,
  username,
  lib,
}: let
  domain = builtins.elemAt (lib.splitString "@" email) 1;
in {
  sops.secrets.email = {
    owner = config.users.users."${username}".name;
    inherit (config.users.users."${username}") group;
  };

  programs.msmtp = {
    enable = true;
    setSendmail = true;
    accounts.default = {
      host = domain;
      port = 587;
      auth = true;
      from = email;
      user = email;
      tls = true;
      tls_starttls = true;
      passwordeval = "cat ${config.sops.secrets.msmtp.path}";
    };
  };
}
