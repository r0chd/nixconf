{colorscheme}: let
  colorschemes = {
    catppuccin = {
      name = "catppuccin";
      text = "FFFFFF";
      accent1 = "C5A8EB";
      accent2 = "C9CBFF";
      background1 = "170E1F";
      background2 = "140F21";
      error = "CA8080";
      special = "A6E3A1";
      inactive = "1E1E2E";
      warn = "DD7878";
    };
  };
in
  colorschemes."${colorscheme}"
