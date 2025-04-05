{
  shell,
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (shell == "nushell") {
    home = {
      shell.enableNushellIntegration = true;
      persist.files = [ ".config/nushell/history.txt" ];
    };
    programs = {
      nushell = {
        enable = true;
        package = null;
        inherit (config.home) shellAliases;
        extraConfig = ''
          let carapace_completer = {|spans: list<string>|
              ${pkgs.carapace}/bin/carapace $spans.0 nushell ...$spans
              | from json
              | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
          }

          let zoxide_completer = {|spans|
              $spans | skip 1 | ${pkgs.zoxide}/bin/zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
          }

          let external_completer = {|spans|
              let expanded_alias = scope aliases
              | where name == $spans.0
              | get -i 0.expansion

              let spans = if $expanded_alias != null {
                  $spans
                  | skip 1
                  | prepend ($expanded_alias | split row ' ' | take 1)
              } else {
                  $spans
              }

              match $spans.0 {
                  __zoxide_z => $zoxide_completer,
                  __zoxide_zi => $zoxide_completer,
                  _ => $carapace_completer
              } | do $in $spans
          }

          $env.config = {
            show_banner: false
            edit_mode: "vi"
            completions: {
              algorithm: "fuzzy"
              case_sensitive: false
              quick: true
              partial: true
              sort: "smart"
              external: {
                enable: true
                max_results: 100
                completer: $external_completer
              }
            }
            cursor_shape: {
              vi_insert: line
              vi_normal: block
            }
            keybindings: [
              {
                name: completion_menu
                modifier: none
                keycode: tab
                mode: [vi_insert vi_normal]
                event: { send: menu name: completion_menu }
              },
            ]
            use_kitty_protocol: true
            render_right_prompt_on_last_line: false
          }
        '';
        extraEnv = ''
          $env.TRANSIENT_PROMPT_COMMAND = ">"
          $env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
        '';
      };
      carapace.enable = true;
    };
  };
}
