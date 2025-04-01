{
  pkgs,
  config,
  lib,
  shell,
  ...
}:
let
  cfg = config.programs.multiplexer;
in
{
  config = lib.mkIf (cfg.enable && cfg.variant == "tmux") {
    programs = {
      tmux = {
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
          {
            plugin = resurrect;
            extraConfig = "set -g @resurrect-strategy-nvim 'session'";
          }
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

          run '~/.config/tmux/plugins/tpm/tpm'
        '';
      };

      bash.initExtra = lib.mkIf (shell == "bash") ''
        tmux-init
      '';
      zsh.initExtra = lib.mkIf (shell == "zsh") ''
        tmux-init
      '';
      nushell.loginFile.text = ''
        tmux-init
      '';
      fish.interactiveShellInit = lib.mkIf (shell == "fish") ''
        if string match -q -- 'tmux*' $TERM
            set fish_cursor_insert line
        end

        tmux-init
      '';
    };

    home.packages = with pkgs; [
      (writeShellScriptBin "tmux-init"
        # bash
        ''
          if [ -z "$TMUX" ]; then
            i=0
            while true; do
                session_name="base-$i"
                if tmux has-session -t "$session_name" 2>/dev/null; then
                    clients_count=$(tmux list-clients | grep $session_name | wc -l)
                    if [ $clients_count -eq 0 ]; then
                        tmux attach-session -t $session_name
                        break
                    fi
                    ((i++))
                else
                    tmux new-session -d -s $session_name
                    tmux attach-session -d -t $session_name
                    tmux set-option -g set-clipboard on
                    tmux bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "wl-copy"
                    break
                fi
            done
          fi
        ''
      )
    ];

  };
}
