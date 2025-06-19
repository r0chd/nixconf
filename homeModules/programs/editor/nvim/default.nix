{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.programs.editor == "nvim") {
    home = {
      packages = with pkgs; [
        inputs.nixvim.packages.${system}.default
        ripgrep
        tree-sitter
        fd
      ];

      persist.directories = [
        ".local/share/nvim"
        ".local/state/nvim"
      ];
    };
  };
}
