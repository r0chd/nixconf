{ pkgs, inputs, conf, lib }: {
  options.editor = lib.mkOption { type = lib.types.enum [ "nvim" ]; };

  config = lib.mkIf (conf.editor == "nvim") {
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
      variables.EDITOR = "nvim";
    };
  };
}
