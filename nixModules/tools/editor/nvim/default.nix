{ pkgs, inputs, config, lib, ... }: {
  config = lib.mkIf (config.editor == "nvim") {
    environment = {
      systemPackages = with pkgs; [
        inputs.nixvim.packages.${system}.default
        ripgrep
        tree-sitter
        fd
        adwaita-icon-theme
        lua-language-server
        alejandra
        nixfmt-classic
        gcc
        stylua
      ];
      shellAliases = {
        vi = "nvim";
        vim = "nvim";
      };
    };

    impermanence.persist-home.directories =
      [ ".cache/nvim" ".local/share/nvim" ".local/state/nvim" ];
  };
}
