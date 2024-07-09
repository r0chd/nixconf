{
  pkgs,
  username,
  colorscheme,
  ...
}: let
  colors =
    if colorscheme == "catppuccin"
    then ["196" "155" "189" "214" "219"]
    else [];
  getColor = index: "${builtins.elemAt colors index}";
in {
  environment.systemPackages = with pkgs; [fzf];

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;
  home-manager.users."${username}".programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    history = {
      size = 10000;
      path = "/home/${username}/.zsh_history";
      ignoreSpace = true;
      ignoreAllDups = true;
      ignoreDups = true;
    };
    autosuggestion.enable = true;
    initExtra = ''
      eval "$(fzf --zsh)"

      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors '$\\{(s.:.)LS_COLORS}'
      zstyle ':completion:*' menu no

      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls $realpath'

      bindkey '^[[A' history-search-backward
      bindkey '^[[B' history-search-forward

      if [ -z "$TMUX" ]; then
        TMUX=$(tmux new-session -d -s base)
        eval $TMUX
        tmux attach-session -d -t base
      fi

      # -------------------------------------- PS1 -------------------------------------- #

      _git_branch() {
        local branch
        branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        if [[ -n "$branch" ]]; then
            echo "%F{${getColor 2}}git:(%f%F{${getColor 3}}$branch%f%F{${getColor 2}})%f "
        fi
      }

      _current_dir() {
        local dir
        if [[ "$PWD" == "$HOME" ]]; then
            dir="~"
        else
          dir=$(basename $PWD)
        fi
        echo "%F{${getColor 2}}''${dir}%f"
      }

      _vi_mode() {
        case ''${KEYMAP} in
            (vicmd)
                printf "\033[2 q"
                echo "%F{${getColor 0}}[N]%f"
            ;;
            (*)
                printf "\033[6 q"
                echo "%F{${getColor 1}}[I]%f"
            ;;
        esac
      }

      function zle-line-init zle-keymap-select () {
        PS1=" $(_vi_mode) $(_current_dir) $(_git_branch)%F{${getColor 4}}%f "

        zle reset-prompt
      }

      zle -N zle-keymap-select
      zle -N zle-line-init

      bindkey -v
    '';
    zplug = {
      enable = true;
      plugins = [
        {name = "zsh-users/zsh-completions";}
        {name = "Aloxaf/fzf-tab";}
      ];
    };
  };
}
