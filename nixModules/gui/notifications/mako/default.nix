{conf}: let
  inherit (conf) username colorscheme;
in {
  home-manager.users."${username}".services.mako = let
    inherit (colorscheme) background1 accent2;
  in {
    enable = true;
    backgroundColor = "#${background1}FF";
    borderColor = "#${accent2}FF";
    defaultTimeout = 10000;
    borderRadius = 5;
  };
}
