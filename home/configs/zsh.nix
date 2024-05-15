{...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion = {
      enable = true;
    };
    dotDir = ".config/zsh";
    shellAliases = {
      ls = "lsd ";
    };
  };
}
