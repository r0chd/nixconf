{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs.vcs;
in
{
  programs.jujutsu = lib.mkIf cfg.jj.enable {
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

      git.push-new-bookmarks = true;

      # True freedom, fully mutable commits
      revset-aliases."immutable_heads()" = "none()";

      templates = {
        commit_trailers = ''
          if(self.author().email() == "${cfg.email}" &&
            !trailers.contains_key("Change-Id"),
            format_gerrit_change_id_trailer(self)
          )
        '';
      };

      aliases = {
        review = [
          "util"
          "exec"
          "--"
          "bash"
          "-c"
          ''
            set -euo pipefail
            INPUT=''${1:-"@"}
            HASH=$(jj log -r "''${INPUT}" -T commit_id --no-graph)
            HASHINFO=$(${pkgs.git}/bin/git log -n 1 ''${HASH} --oneline --color=always)
            echo "Pushing from commit ''${HASHINFO}"
            ${pkgs.git}/bin/git push origin "''${HASH}":refs/for/main
          ''
          ""
        ];
      };
    };
  };
}
