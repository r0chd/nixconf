{username, ...}: {
  home-manager.users."${username}".programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    history = {
      size = 10000;
      path = "~/.zsh_history";
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

      if [ -z "$TMUX" ]; then
          TMUX=$(tmux new-session -d -s base)
          eval $TMUX
          tmux attach-session -d -t base
      fi

      git_branch() {
            local branch
            branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
            if [[ -n "$branch" ]]; then
                echo "%F{189}git:(%f%F{214}$branch%f%F{189})%f "
            fi
        }

        # Define a function to update the PS1 prompt
        update_prompt() {
            local dir
            dir=$(basename "$PWD")
            if [[ "$PWD" == "$HOME" ]]; then
                dir="~"
            fi
            PS1=" %F{189}"$dir"%f $(git_branch)%F{201}%f "
        }

        # Set the prompt initially
        update_prompt

        precmd_functions+=update_prompt
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
