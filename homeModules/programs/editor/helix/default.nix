{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.programs.editor == "hx") {
    home.packages = with pkgs; [ adwaita-icon-theme ];

    programs.helix = {
      enable = true;

      languages = {
        language-server = {
          rust-analyzer.config = {
            checkOnSave.command = "clippy";
            cargo.allFeatures = true;
          };

          tailwindcss = {
            command = "tailwindcss-language-server";
            args = [ "--stdio" ];
            settings = {
              tailwindCSS = {
                experimental = {
                  classRegex = [ "class: \"(.*)\"" ];
                };
                includeLanguages = {
                  rust = "html";
                };
              };
            };
          };

          wgsl-analyzer.command = "wgsl-analyzer";
        };
        language = [
          {
            name = "rust";
            auto-format = true;
            formatter.command = "cargo fmt";
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
            formatter.command = "wgslfmt";
          }
          {
            name = "nix";
            auto-format = true;
            language-servers = [ "${pkgs.nixd}/bin/nixd" ];
            formatter = {
              command = lib.getExe pkgs.nixfmt-rfc-style;
              args = [ "-s" ];
            };
          }
          {
            name = "markdown";
            auto-format = true;
            formatter = {
              command = "dprint";
              args = [
                "fmt"
                "--stdin"
                "md"
              ];
            };
          }
          {
            name = "javascript";
            auto-format = true;
            formatter = {
              command = "prettierd";
              args = [
                "--stdin-filepath"
                "file.js"
              ];
            };
          }
          {
            name = "typescript";
            auto-format = true;
            formatter = {
              command = "prettierd";
              args = [
                "--stdin-filepath"
                "file.ts"
              ];
            };
          }
          {
            name = "jsx";
            auto-format = true;
            formatter = {
              command = "prettierd";
              args = [
                "--stdin-filepath"
                "file.jsx"
              ];
            };
          }
          {
            name = "tsx";
            auto-format = true;
            formatter = {
              command = "prettierd";
              args = [
                "--stdin-filepath"
                "file.tsx"
              ];
            };
          }

        ];
      };
      settings = {
        editor = {
          file-picker.hidden = true;
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
