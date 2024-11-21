{
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.shell == "zsh") {
    impermanence.persist.files = [ ".zsh_history" ];
    home.packages = with pkgs; [ fzf ];
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      history = {
        size = 10000;
        path = "/home/${config.home.username}/.zsh_history";
        ignoreSpace = true;
        ignoreAllDups = true;
        ignoreDups = true;
      };
      autosuggestion.enable = true;
      initExtra =
        let
          inherit (config) colorscheme;
          inherit (colorscheme)
            accent1
            accent2
            error
            special
            warn
            ;
        in
        ''
          eval "$(fzf --zsh)"

          zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
          zstyle ':completion:*' list-colors '$\\{(s.:.)LS_COLORS}'
          zstyle ':completion:*' menu no

          zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls $realpath'

          bindkey '^[[A' history-search-backward
          bindkey '^[[B' history-search-forward

          # -------------------------------------- PS1 -------------------------------------- #

          _git_branch() {
            local branch
            branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
            if [[ -n "$branch" ]]; then
                echo "%F{#${accent2}}git:(%f%F{#${warn}}$branch%f%F{#${accent2}})%f "
            fi
          }

          _current_dir() {
            local dir
            if [[ "$PWD" == "$HOME" ]]; then
                dir="~"
            else
              dir=$(basename $PWD)
            fi
            echo "%F{#${accent2}}''${dir}%f"
          }

          _vi_mode() {
            case ''${KEYMAP} in
                (vicmd)
                    printf "\033[2 q"
                    echo "%F{#${error}}[N]%f"
                ;;
                (*)
                    printf "\033[6 q"
                    echo "%F{#${special}}[I]%f"
                ;;
            esac
          }

          function zle-line-init zle-keymap-select () {
            PS1=" $(_vi_mode) $(_current_dir) $(_git_branch)%F{#${accent1}}%f "

            zle reset-prompt
          }

          zle -N zle-keymap-select
          zle -N zle-line-init

          bindkey -v
        '';
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
