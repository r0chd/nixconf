{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.programs.editor == "hx") {
    home.packages = with pkgs; [
      adwaita-icon-theme
      nixd
    ];

    programs.helix = {
      enable = true;

      languages = {
        language-server = {
          rust-analyzer.config = {
            files = {
              excludeDirs = [ "node_modules" ];
            };
            procMacro.enabled = true;
            cargo.buildScripts.enable = true;
            diagnostics.disabled = [ "unresolved-proc-macro" ];
            check.command = "clippy";
            cargo.features = "all";
            inlayHints = {
              maxLength = 25;
              discriminantHints.enable = true;
              closureReturnTypeHints.enable = true;
              closureCaptureHints.enable = true;
              parameterHints = true;
              typeHints = true;
              expressionReturnTypeHints.enable = true;
            };
          };
          tailwindcss = {
            command = "tailwindcss-language-server";
            args = [ "--stdio" ];
          };
        };
        language = [
          {
            name = "rust";
            auto-format = true;
            formatter.command = "rustfmt";
            injection-regex = "rsx";
            language-servers = [ "rust-analyzer" ];
            grammar = "rust";
            scope = "source.rust";
            file-types = [
              "rs"
              "rsx"
            ];
          }
          {
            name = "wgsl";
            auto-format = true;
            file-types = [ "wgsl" ];
            indent = {
              tab-width = 4;
              unit = "    ";
            };
            language-servers = [ "wgsl-analyzer" ];
          }
          {
            name = "nix";
            auto-format = true;
            language-servers = [ { name = "nixd"; } ];
            formatter = {
              command = lib.getExe pkgs.nixfmt-rfc-style;
              args = [ "-s" ];
            };
          }
        ];
      };
      settings = {
        editor = {
          true-color = true;
          color-modes = true;
          auto-pairs = true;
          line-number = "relative";
          lsp.display-messages = true;
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
        };

        keys.normal = {
          esc = [
            "collapse_selection"
            "keep_primary_selection"
          ];
        };
      };
    };
  };
}
