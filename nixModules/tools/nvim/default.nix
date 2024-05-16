_: {
  programs = {
    neovim = {
      enable = true;
      vimAlias = true;
    };
  };
  environment.sessionVariables.EDITOR = "nvim";
}
