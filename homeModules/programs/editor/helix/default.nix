{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.editor == "hx") {
    home.packages = with pkgs; [
      adwaita-icon-theme
      lua-language-server
      alejandra
      nixfmt-rfc-style
      stylua
    ];

    programs.helix = {
      enable = true;

      languages = {
        language-server.rust-analyzer.config = {
          files = {
            excludeDirs = [ "node_modules" ];
          };
          procMacro.enabled = true;
          inlayHints = {
            maxLength = 25;
            discriminantHints.enable = true;
            closureReturnTypeHints.enable = true;
            closureCaptureHints.enable = true;
          };
        };
        language = [
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
