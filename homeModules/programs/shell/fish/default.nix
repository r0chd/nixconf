{
  config,
  lib,
  shell,
  ...
}:
with config.lib.stylix.colors.withHashtag;
with config.stylix.fonts;
{
  config = lib.mkIf (shell == "fish") {
    impermanence.persist.directories = [ ".local/share/fish" ];
    programs.fish = {
      enable = true;
      functions = {
        fish_mode_prompt = {
          body = ''
            switch $fish_bind_mode
              case default
                echo -en "\e[2 q"
                set_color -o '${base08}'
                echo " [N]"
              case insert
                echo -en "\e[6 q"
                set_color -o '${base0B}'
                echo " [I]"
              end
              set_color normal
          '';
        };
        fish_prompt = {
          body = ''
            echo -s ' '(set_color '${base0D}' --bold)(basename (prompt_pwd)) (set_color '${base0D}' --bold) (fish_git_prompt " git:("(set_color FAB387 --bold)"%s"(set_color '${base0D}' --bold)")") (set_color '${base0E}' --bold)'  '
          '';
        };
        fish_vi_on_paging = {
          body = ''
            commandline -f complete
            if commandline --paging-mode
            commandline -f repaint
            set fish_bind_mode default
            end
          '';
        };
      };
      loginShellInit = ''
        fish_vi_key_bindings;

        bind --mode insert \t fish_vi_on_paging
      '';

      interactiveShellInit = ''
        bind --mode insert \t fish_vi_on_paging

        set -g fish_greeting ""
      '';
    };
  };
}
