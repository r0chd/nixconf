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
          {
            name = "nix";
            auto-format = true;
            language-servers = [ { name = "nil"; } ];
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
