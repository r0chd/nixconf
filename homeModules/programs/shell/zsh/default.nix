{
  pkgs,
  config,
  lib,
  shell,
  ...
}:
with config.lib.stylix.colors.withHashtag;
with config.stylix.fonts;
{
  config = lib.mkIf (shell == "zsh") {
    home = {
      shell.enableZshIntegration = true;
      packages = with pkgs; [ fzf ];
      persist = {
        directories = [
          ".zplug"
          ".cache/zsh"
        ];
      };
    };
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      history = {
        size = 10000;
        path = "/home/${config.home.username}/.cache/zsh/history";
        ignoreSpace = true;
        ignoreAllDups = true;
        ignoreDups = true;
      };
      autosuggestion.enable = true;
      initExtra =
        let
          transientPrompt = ''
            TRANSIENT_PROMPT=$(starship module character)
            function zle-line-init() {
                emulate -L zsh

                [[ $CONTEXT == start ]] || return 0
                while true; do
                    zle .recursive-edit
                    local -i ret=$?
                    [[ $ret == 0 && $KEYS == $'\4' ]] || break
                    [[ -o ignore_eof ]] || exit 0
                done

                local saved_prompt=$PROMPT
                local saved_rprompt=$RPROMPT

                PROMPT=$TRANSIENT_PROMPT
                zle .reset-prompt
                PROMPT=$saved_prompt

                if (( ret )); then
                    zle .send-break
                else
                    zle .accept-line
                fi
                return ret
            }
          '';
        in
        ''
          eval "$(fzf --zsh)"

          zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
          zstyle ':completion:*' list-colors '$\\{(s.:.)LS_COLORS}'
          zstyle ':completion:*' menu no

          zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls $realpath'

          bindkey '^[[A' history-search-backward
          bindkey '^[[B' history-search-forward

          bindkey -v
        ''
        + lib.optionalString (
          config.programs.starship.enable && config.programs.starship.enableTransience
        ) transientPrompt;
      zplug = {
        enable = true;
        plugins = [
          { name = "zsh-users/zsh-completions"; }
          { name = "Aloxaf/fzf-tab"; }
        ];
      };
    };
  };
}
