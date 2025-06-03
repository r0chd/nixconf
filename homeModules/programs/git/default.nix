{ config, lib, ... }:
let
  cfg = config.programs.git;
in
{
  options.programs.git = {
    signingKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
    email = lib.mkOption { type = lib.types.nullOr lib.types.str; };
  };

  config = {
    programs.git = {
      enable = true;
      userName = config.home.username;
      userEmail = cfg.email;

      signing = lib.mkIf (cfg.signingKeyFile != null) {
        key = cfg.signingKeyFile;
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
        user.signing.key = lib.mkIf (cfg.signingKeyFile != null) cfg.signingKeyFile;
      };
    };

    programs.jujutsu = {
      enable = true;
      settings = {
        ui.paginate = "never";
        user = {
          name = config.home.username;
          inherit (cfg) email;
        };
        signing = {
          behavior = "own";
          backend = "ssh";
          key = lib.mkIf (cfg.signingKeyFile != null) cfg.signingKeyFile;
          backends.ssh.allow-singers = "${config.home.homeDirectory}/.ssh/allowed_signers";
        };
      };
    };
  };
}
