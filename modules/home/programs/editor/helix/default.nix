{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:
let
  groovyls =
    pkgs.runCommand "groovy-language-server"
      {
        src = builtins.fetchurl {
          url = "https://github.com/Moonshine-IDE/Moonshine-IDE/raw/216aa139620d50995a14827e949825c522bd85e5/ide/MoonshineSharedCore/src/elements/groovy-language-server/groovy-language-server-all.jar";
          sha256 = "sha256:1iq8c904xsyv7gf4i703g7kb114kyq6cg9gf1hr1fzvy7fpjw0im";
        };
        buildInputs = [ pkgs.makeWrapper ];
      }
      ''
        mkdir -p $out/{bin,share/groovy-language-server}/
        ln -s $src $out/share/groovy-language-server/groovy-language-server-all.jar
        makeWrapper ${pkgs.jre}/bin/java $out/bin/groovy-language-server \
          --argv0 crowdin \
          --add-flags "-jar $out/share/groovy-language-server/groovy-language-server-all.jar"
      '';
in
{
  config = lib.mkIf (config.programs.editor == "hx") {
    programs.helix = {
      enable = true;
      languages = {
        language-server = {
          groovy-language-server.command = "${groovyls}/bin/groovy-language-server";

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

          biome = {
            command = "biome";
            args = [ "lsp-proxy" ];
          };

          tailwindcss-ls = {
            command = "tailwindcss-language-server";
            args = [ "--stdio" ];
          };

          wgsl-analyzer.command = "wgsl-analyzer";

          steel-language-server.command = "${pkgs.steel}/bin/steel-language-server";
        };
        language = [
          {
            name = "yaml";
            auto-format = true;
            formatter = {
              command = "prettier";
              args = [
                "--parser"
                "yaml"
              ];
            };
          }
          {
            name = "scheme";
            auto-format = true;
            language-servers = [ "steel-language-server" ];
          }
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
            name = "groovy";
            scope = "source.groovy";
            injection-regex = "groovy";
            auto-format = true;
            file-types = [
              "groovy"
              "Jenkinsfile"
            ];
            shebangs = [ "groovy" ];
            roots = [ ];
            comment-token = "//";
            language-servers = [ "groovy-language-server" ];
            indent = {
              tab-width = 2;
              unit = "  ";
            };
            grammar = "groovy";
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
            language-servers = [
              {
                name = "typescript-language-server";
                except-features = [ "format" ];
              }
              "biome"
              "tailwindcss-ls"
            ];
            formatter = {
              command = "biome";
              args = [
                "format"
                "--stdin-file-path"
                "test.tsx"
              ];
            };
          }
          {
            name = "typescript";
            auto-format = true;
            language-servers = [
              {
                name = "typescript-language-server";
                except-features = [ "format" ];
              }
              "biome"
              "tailwindcss-ls"
            ];
            formatter = {
              command = "biome";
              args = [
                "format"
                "--stdin-file-path"
                "test.tsx"
              ];
            };
          }
          {
            name = "jsx";
            auto-format = true;
            language-servers = [
              {
                name = "typescript-language-server";
                except-features = [ "format" ];
              }
              "biome"
              "tailwindcss-ls"
            ];
            formatter = {
              command = "biome";
              args = [
                "format"
                "--stdin-file-path"
                "test.tsx"
              ];
            };
          }
          {
            name = "tsx";
            auto-format = true;
            language-servers = [
              {
                name = "typescript-language-server";
                except-features = [ "format" ];
              }
              "biome"
              "tailwindcss-ls"
            ];
            formatter = {
              command = "biome";
              args = [
                "format"
                "--stdin-file-path"
                "test.tsx"
              ];
            };
          }
          {
            name = "jsonnet";
            auto-format = true;
          }
        ];

        grammar = [
          {
            name = "groovy";
            source = {
              git = "https://github.com/codieboomboom/tree-sitter-groovy";
              rev = "de8e0c727a0de8cbc6f4e4884cba2d4e7c740570";
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

    home.file.".steel/cogs/helix-ext.scm".text =
      # scheme
      ''
        (require "helix/editor.scm")
        (require "helix/misc.scm")
        (require-builtin helix/core/text as text.)
        (require "steel/sync")

        (provide eval-buffer
                 evalp
                 running-on-main-thread?
                 hx.with-context
                 hx.block-on-task)

        (define (get-document-as-slice)
          (let* ([focus (editor-focus)]
                 [focus-doc-id (editor->doc-id focus)])
            (text.rope->string (editor->text focus-doc-id))))

        ;;@doc
        ;; Eval the current buffer, morally equivalent to load-buffer!
        (define (eval-buffer)
          (eval-string (get-document-as-slice)))

        ;;@doc
        ;; Eval prompt
        (define (evalp)
          (push-component! (prompt "" (lambda (expr) (set-status! (eval-string expr))))))

        ;;@doc
        ;; Check what the main thread id is, compare to the main thread
        (define (running-on-main-thread?)
          (= (current-thread-id) *helix.id*))

        ;;@doc
        ;; If running on the main thread already, just do nothing.
        ;; Check the ID of the engine, and if we're already on the
        ;; main thread, just continue as is - i.e. just block.
        (define (hx.with-context thunk)
          (if (running-on-main-thread?)
              (thunk)
              (begin
                (define task (task #f))
                ;; Send on the main thread
                (acquire-context-lock thunk task)
                task)))

        ;;@doc
        ;; Block on the given function.
        (define (hx.block-on-task thunk)
          (if (running-on-main-thread?) (thunk) (block-on-task (hx.with-context thunk))))
      '';

    xdg.configFile."helix/init.scm".text =
      # scheme
      ''
        (require "helix-ext.scm")
      '';
  };
}
