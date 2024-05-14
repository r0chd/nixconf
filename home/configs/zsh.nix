{...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestions = {
      enable = true;
    };
    defaultKeymap = "viicmd";
    dotDir = ".config/zsh";
    shellAliases = {
      ls = "lsd ";
      cat = "bat ";
      vim = "nvim ";
    };
    interactiveShellInit = ''
      if not set -q TMUX
        set -g TMUX tmux new-session -d -s base
        eval $TMUX
        tmux attach-session -d -t base
      end

      zoxide init --cmd cd fish | source
    '';
  };
}
