{
  config,
  std,
  username,
  ...
}:
let
  publicKey = "${std.dirs.home}/.ssh/id_ed25519";
in
{
  programs.git = {
    enable = true;
    userName = username;
    userEmail = config.email;
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
      user.signing.key = publicKey;
    };
  };
}
