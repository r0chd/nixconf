{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.git;
in
{
  options.programs.git = {
    identityFile = lib.mkOption {
      type = lib.types.nullOr (lib.types.listOf lib.types.str);
      default = null;
    };
    signingKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
    email = lib.mkOption { type = lib.types.nullOr lib.types.str; };
  };

  config = {
    programs = {
      ssh.matchBlocks = lib.mkIf (cfg.identityFile != null) {
        "git" = {
          host = "github.com";
          user = "git";
          forwardAgent = true;
          identitiesOnly = true;
          inherit (cfg) identityFile;
        };
      };

      git = {
        enable = true;
        userName = config.home.username;
        userEmail = cfg.email;

        signing = lib.mkIf (cfg.signingKeyFile != null) {
          key = cfg.signingKeyFile;
          format = "ssh";
          signByDefault = true;
        };

        aliases = {
          rev = "review --no-rebase --reviewers ${cfg.userName}";
        };

        extraConfig = {
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

      jujutsu = {
        enable = true;
        settings = {
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

          templates = {
            commit_trailers = ''
              if(self.author().email() == "${cfg.email}" &&
                !trailers.contains_key("Change-Id"),
                format_gerrit_change_id_trailer(self)
              )
            '';
          };

          aliases = {
            cl-up = [
              "util"
              "exec"
              "--"
              "bash"
              "-c"
              ''
                set -euo pipefail
                INPUT=''${1:-"@-"}
                HASH=$(jj log -r "''${INPUT}" -T commit_id --no-graph)
                HASHINFO=$(git log -n 1 ''${HASH} --oneline --color=always)
                echo "Pushing from commit ''${HASHINFO}"
                git push origin "''${HASH}":refs/for/main                  
              ''
              ""
            ];
          };
        };
      };
    };

    home.packages = [ pkgs.git-review ];
  };
}
