{ config, lib, ... }:
let
  cfg = config.programs.git;
in
{
  options.programs.git.signingKey = {
    enable = lib.mkEnableOption "signing key";
    file = lib.mkOption { type = lib.types.str; };
  };

  config.programs.git = {
    enable = true;
    userName = config.home.username;
    userEmail = config.email;

    signing = lib.mkIf cfg.signingKey.enable {
      key = cfg.signingKey.file;
      format = "ssh";
      signByDefault = true;
    };

    extraConfig = {
      init.defaultBranch = "main";
      #url = {
      #"ssh://git@github.com" = {
      #insteadOf = "https://github.com";
      #};
      #"ssh://git@gitlab.com" = {
      #insteadOf = "https://gitlab.com";
      #};
      #};
      gpg = {
        format = "ssh";
        ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";
      };
      user.signing.key = lib.mkIf cfg.signingKey.enable cfg.signingKey.file;
      safe.directory = [ "/var/lib/nixconf" ];
    };
  };
}
