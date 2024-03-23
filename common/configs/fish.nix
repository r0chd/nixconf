{pkgs, ...}: {
  programs.fish = {
    enable = true;
    package = pkgs.fish;
    functions = {
      fish_vi_on_paging = {
        body = " 
            commandline -f complete
            if commandline --paging-mode
              commandline -f repaint
              set fish_bind_mode default
            end
        ";
      };
    };
    loginShellInit = ''
      fish_add_path ~/.cargo/bin

      if string match -q -- 'tmux*' $TERM
          set fish_cursor_insert line
      end

      function qutebrowser
        tmux new-session -d -s qutebrowser qutebrowser
        tmux attach-session -d -t qutebrowser
      end

      function discord
        tmux new-session -d -s discord discord
        tmux attach-session -d -t discord
      end

      fish_vi_key_bindings;

      bind --mode insert \t fish_vi_on_paging
    '';

    shellAliases = {
      ls = "lsd ";
      doas = "doas ";
      rebuild-wayland = "doas nixos-rebuild switch --flake ~/nixconf/#waylandconf --impure";
      rebuild-xorg = "doas nixos-rebuild switch --flake ~/nixconf/#xorgconf --impure";
      vim = "nvim ";
    };

    interactiveShellInit = ''
      function fish_prompt
        echo -s ' '(set_color C6D0F5 --bold)(basename (prompt_pwd)) (set_color C6D0F5 --bold) (fish_git_prompt " git:("(set_color FAB387 --bold)"%s"(set_color C6D0F5 --bold)")") (set_color FFB1D2 --bold)'  '
      end

      bind --mode insert \t fish_vi_on_paging

      function fish_mode_prompt
        switch $fish_bind_mode
          case default
            echo -en "\e[2 q"
            set_color -o F38BA8
            echo " ["
            set_color -o F38BA8
            echo N
            set_color -o F38BA8
            echo "]"
          case insert
            echo -en "\e[6 q"
            set_color -o A6E3A1
            echo " ["
            set_color -o A6E3A1
            echo I
            set_color -o A6E3A1
            echo "]"
          case replace_one
            echo -en "\e[4 q"
            set_color -o FAB387
            echo " ["
            set_color -o FAB387
            echo R
            set_color -o FAB387
            echo "]"
        end
        set_color normal
      end

      set -g fish_greeting ""

      if not set -q TMUX
        set -g TMUX tmux new-session -d -s base
        eval $TMUX
        tmux attach-session -d -t base
      end

      zoxide init --cmd cd fish | source
    '';
  };
}
