_: {
  imports = [(import ./home.nix)];
  programs = {
    neovim = {
      enable = true;
      vimAlias = true;
    };
  };
  environment.sessionVariables.EDITOR = "nvim";
}
