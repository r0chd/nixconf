{
  pkgs,
  inputs,
  ...
}: {
  programs = {
    neovim = {
      enable = true;
      vimAlias = true;
      defaultEditor = true;
    };
  };
  environment.systemPackages = with pkgs; [
    inputs.nvim-conf.packages.${system}.default
    ripgrep
    nodejs_22
    tree-sitter
    fd
    gnome3.adwaita-icon-theme
  ];
  environment.sessionVariables.EDITOR = "nvim";
}
