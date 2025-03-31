{ config, ... }:
let
  publicKey = "${config.home.homeDirectory}/.ssh/id_yubikey.pub";
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
      gpg = {
        format = "ssh";
        ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";
      };
      user.signing.key = publicKey;
      safe.directory = [ "/var/lib/nixconf" ];
    };
  };
}
