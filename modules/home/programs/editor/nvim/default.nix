{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.programs.editor == "nvim") {
    programs.neovim = {
      withPython3 = false;
      withRuby = false;
    };

    home = {
      packages = [
        inputs.nixvim.packages.${pkgs.system}.default
      ]
      ++ builtins.attrValues { inherit (pkgs) ripgrep tree-sitter fd; };

      persist.directories = [
        ".local/share/nvim"
        ".local/state/nvim"
      ];
    };
  };
}
