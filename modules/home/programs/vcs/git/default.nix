{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.vcs;
  inherit (lib) types;
in
{
  options.programs.vcs.git = {
    enable = lib.mkOption {
      type = types.bool;
      default = true;
    };
    package = lib.mkPackageOption pkgs "git" { };
  };

  config = lib.mkIf cfg.git.enable {
    programs.git = {
      enable = true;

      signing = lib.mkIf (cfg.signingKeyFile != null) {
        key = cfg.signingKeyFile;
        format = "ssh";
        signByDefault = true;
      };

      settings = {
        user = { inherit (cfg) name email; };

        alias = {
          rev = "review --no-rebase --reviewers ${config.home.username}";
        };

        #diff.tool = "kdiff3";
        #merge.tool = "kdiff3";

        #difftool."kdiff3".cmd = "${pkgs.kdiff3}/bin/kdiff3 \"$LOCAL\" \"$REMOTE\"";
        #mergetool."kdiff3" = {
        #  cmd = "${pkgs.kdiff3}/bin/kdiff3 \"$LOCAL\" \"$REMOTE\" -o \"$MERGED\"";
        #  trustExitCode = true;
        #  keepBackup = false;
        #};

        init.defaultBranch = "master";
        gpg = {
          format = "ssh";
          ssh.allowedSignersFile = "${config.home.homeDirectory}/.ssh/allowed_signers";
        };
        user.signing.key = lib.mkIf (cfg.signingKeyFile != null) cfg.signingKeyFile;
      };
    };

    home.packages = [ pkgs.git-review ];
  };
}
