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
    impermanence.persist = {
      files = [ ".zsh_history" ];
      directories = [ ".zplug" ];
    };
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
      initExtra = ''
        eval "$(fzf --zsh)"

        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' list-colors '$\\{(s.:.)LS_COLORS}'
        zstyle ':completion:*' menu no

        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls $realpath'

        bindkey '^[[A' history-search-backward
        bindkey '^[[B' history-search-forward
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
