{
  username,
  config,
}: let
  publicKey = "/home/${username}/.ssh/id_ed25519";
in {
  home-manager.users."${username}".programs.git = {
    enable = true;
    userName = "${username}";
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
      signing = {
        signByDefault = true;
        key = publicKey;
      };
      gpg.format = "ssh";
      user.signing.key = "${publicKey}";
    };
  };
}
