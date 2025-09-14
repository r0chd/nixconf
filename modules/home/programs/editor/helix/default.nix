{
  lib,
  config,
  pkgs,
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
          clangd = {
            command = "clangd";
            args = [
              "--background-index"
              "--clang-tidy"
              "--header-insertion=iwyu"
            ];
          };

          nixd = {
            command = "${pkgs.nixd}/bin/nixd";
            args = [
              "--semantic-tokens=true"
              "--inlay-hints=true"
            ];
            config.nixd =
              let
                flake = "(builtins.getFlake (toString /var/lib/nixconf))";
              in
              {
                nixpkgs.expr = "import ${flake}.inputs.nixpkgs { }";
                formatting.command = [ "nixfmt" ];
                options = {
                  nixos.expr = "${flake}.nixosConfigurations.${config.networking.hostName}.options";
                  home-manager.expr = "${flake}.homeConfigurations.${config.home.username}@${config.networking.hostName}.options";
                };
              };
          };

          groovy-language-server.command = "${groovyls}/bin/groovy-language-server";

          rust-analyzer.config = {
            checkOnSave = {
              command = "${pkgs.clippy}/bin/clippy";
              args = [
                "--"
                "-W"
                "clippy::pedantic"
                "-W"
                "clippy::correctness"
                "-W"
                "clippy::suspicious"
                "-W"
                "clippy::cargo"
              ];
              features = "all";
              workspace = true;
            };
            diagnostics.experimental.enable = true;
            hover.actions.enable = true;
            typing.autoClosingAngleBrackets.enable = true;
            cargo.allFeatures = true;
            procMacro.enable = true;
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
            name = "c";
            auto-format = true;
            formatter.command = "clang-format";
            language-servers = [ "clangd" ];
          }
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
            name = "vrl";
            scope = "source.vrl";
            auto-format = true;
            file-types = [ "vrl" ];
            indent = {
              tab-width = 2;
              unit = "  ";
            };
            comment-token = "#";
            grammar = "vrl";
          }
          {
            name = "wgsl";
            auto-format = true;
            formatter.command = "wgslfmt";
          }
          {
            name = "nix";
            auto-format = true;
            language-servers = [ "nixd" ];
            formatter = {
              command = lib.getExe pkgs.nixfmt;
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
          {
            name = "solidity";
            auto-format = true;
            formatter = {
              command = "forge";
              args = [
                "fmt"
                "-"
                "--raw"
                "--threads"
                "0"
              ];
            };
          }
          {
            name = "nu";
            auto-format = true;
            #formatter.command = "nufmt"; TODO: do it once nufmt is stabilized
          }
          {
            name = "typst";
            auto-format = true;
            formatter = {
              command = "typstfmt";
              args = [
                "--output"
                "-"
              ];
            };
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
          {
            name = "vrl";
            source = {
              git = "https://github.com/belltoy/tree-sitter-vrl";
              rev = "274b3ce63f72aa8ffea18e7fc280d3062d28f0ba";
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
          space = {
            i = ":toggle lsp.display-inlay-hints";
            l = ":sh git log -n 5 --format='format:%%h (%%an: %%ar) %%s' --no-patch -L%{cursor_line},+1:%{buffer_name}";
          };
          #j = ":sh git l"
        };
      };
    };
  };
}
