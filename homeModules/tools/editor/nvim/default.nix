{ pkgs, inputs, config, lib, username, ... }: {
  config = lib.mkIf (config.editor == "nvim") {
    home-manager.users.${username} = {
      home = {
        packages = with pkgs; [
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

      impermanence.persist.directories =
        [ ".cache/nvim" ".local/share/nvim" ".local/state/nvim" ];
    };
  };
}
