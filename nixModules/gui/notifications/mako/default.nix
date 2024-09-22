{conf}: let
  inherit (conf) username colorscheme;
in {
  home-manager.users."${username}".services.mako = let
    inherit (colorscheme) background1 accent1;
  in {
    enable = true;
    backgroundColor = "#${background1}FF";
    borderColor = "#${accent1}FF";
    defaultTimeout = 5000;
    borderRadius = 5;
  };
}
