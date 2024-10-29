{ pkgs, inputs, conf, lib, std }:
let inherit (conf) username;
in {
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
    };

    home-manager.users.${username}.home.persistence.${std.dirs.home-persist}.directories =
      lib.mkIf conf.impermanence.enable [
        ".cache/nvim"
        ".local/share/nvim"
        ".local/state/nvim"
      ];
  };
}
