{
  username,
  pkgs,
  ...
}: let
  rose-pine = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "rose-pine";
    version = "unstable-2023-01-06";
    src = pkgs.fetchFromGitHub {
      owner = "rose-pine";
      repo = "tmux";
      rev = "main";
      sha256 = "sha256-0ccJVQIIOpHdr3xMIBC1wbgsARCNpmN+xMYVO6eu/SI=";
    };
  };
  tokyo-night = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tokyo-night-tmux";
    rtpFilePath = "tokyo-night.tmux";
    version = "1.5.3";
    src = pkgs.fetchFromGitHub {
      owner = "janoamaral";
      repo = "tokyo-night-tmux";
      rev = "d34f1487b4a644b13d8b2e9a2ee854ae62cc8d0e";
      hash = "sha256-3rMYYzzSS2jaAMLjcQoKreE0oo4VWF9dZgDtABCUOtY=";
    };
  };
in {
  home-manager.users."${username}".programs.tmux = {
    enable = true;
    aggressiveResize = true;
    baseIndex = 1;
    clock24 = true;
    keyMode = "vi";
    prefix = "C-space";
    newSession = true;
    secureSocket = true;
    sensibleOnTop = true;
    escapeTime = 0;
    terminal = "screen-256color";
    plugins = with pkgs.tmuxPlugins; [
      yank
      sensible
      vim-tmux-navigator
    ];
    extraConfig = ''
      set -as terminal-features ",xterm-256color:RGB"

      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key x kill-pane

      bind - split-window -v -c "#{pane_current_path}"
      bind | split-window -h -c "#{pane_current_path}"

      set -g renumber-windows on
      set-option -g automatic-rename off
      set-window-option -g window-status-format "#I:#W#F"
      set-window-option -g window-status-current-format "#[bold]#I:#W#F"
      bind-key C-b run-shell "tmux rename-window "$(basename $(pwd))""

      set -g pane-border-style fg="#2A2A2A"
      set -g pane-active-border-style fg="#AFAFAF"

      set -g status-bg "#242424"
      set -g status-fg "#AFAFAF"

      run '~/.config/tmux/plugins/tpm/tpm'
    '';
  };
}
