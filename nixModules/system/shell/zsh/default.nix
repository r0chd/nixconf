{
  pkgs,
  username,
  ...
}: {
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
      eval "$(zoxide init --cmd cd zsh)"

      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
      zstyle ':completion:*' list-colors '$\\{(s.:.)LS_COLORS}'
      zstyle ':completion:*' menu no
      zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd $realpath'

      bindkey '^[[A' history-search-backward
      bindkey '^[[B' history-search-forward

      nvidia() {
        export __NV_PRIME_RENDER_OFFLOAD=1
        export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
        export __GLX_VENDOR_LIBRARY_NAME=nvidia
        export __VK_LAYER_NV_optimus=NVIDIA_only
        exec $argv
      }

      nb() {
        command $argv > /dev/null 2>&1 &; disown;
      }

      if [ -z "$TMUX" ]; then
        TMUX=$(tmux new-session -d -s base)
        eval $TMUX
        tmux attach-session -d -t base
      fi

      _git_branch() {
        local branch
        branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
        if [[ -n "$branch" ]]; then
            echo "%F{189}git:(%f%F{214}$branch%f%F{189})%f "
        fi
      }

      _current_dir() {
        if [[ "$PWD" == "$HOME" ]]; then
            echo "~"
        else
          echo $(basename "$PWD")
        fi
      }

      function zle-line-init zle-keymap-select () {
        case ''${KEYMAP} in
          (vicmd) printf "\033[2 q";;
          (*) printf "\033[6 q";;
        esac

        case ''${KEYMAP} in
          (vicmd)      PS1=" %F{196}[N]%f %F{189}"$(_current_dir)"%f $(_git_branch)%F{219}%f " ;;
          (*)          PS1=" %F{155}[I]%f %F{189}"$(_current_dir)"%f $(_git_branch)%F{219}%f " ;;
        esac

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
        {name = "zsh-users/zsh-autosuggestions";}
        {name = "Aloxaf/fzf-tab";}
      ];
    };
  };
}
