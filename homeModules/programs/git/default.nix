{ config, ... }:
let
  publicKey = "/home/${config.home.username}/.ssh/id_ed25519";
in
{
  programs.git = {
    enable = true;
    userName = config.home.username;
    userEmail = config.email;

    signing = {
      format = "ssh";
      key = publicKey;
      signByDefault = true;
    };

    extraConfig = {
      init.defaultBranch = "main";
      url = {
        "ssh://git@github.com" = {
          insteadOf = "https://github.com";
        };
        "ssh://git@gitlab.com" = {
          insteadOf = "https://gitlab.com";
        };
      };
      gpg.format = "ssh";
      user.signingkey = publicKey;
      safe.directory = [ "/var/lib/nixconf" ];
    };
  };
}
