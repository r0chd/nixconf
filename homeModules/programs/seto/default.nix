{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.seto;
in
{
  imports = [
    inputs.seto.homeManagerModules.default
    inputs.seto.homeManagerModules.stylix
  ];

  #nix.settings = {
  #  substituters = [ "https://seto.cachix.org" ];
  #  trusted-public-keys = [ "seto.cachix.org-1:Hp2sGslAufwWgip0p5QuIzAf1jaREeTp8MuCLU0Io4E=" ];
  #};

  home.packages = lib.mkIf cfg.enable [ pkgs.grim ];
  programs.seto = {
    package = inputs.seto.packages.${pkgs.system}.default;
    settings.keys.bindings = {
      z.move = [
        (-5)
        0
      ];
      x.move = [
        0
        (-5)
      ];
      n.move = [
        0
        5
      ];
      m.move = [
        5
        0
      ];
      Z.resize = [
        (-5)
        0
      ];
      X.resize = [
        0
        5
      ];
      N.resize = [
        0
        (-5)
      ];
      M.resize = [
        5
        0
      ];
      H.move_selection = [
        (-5)
        0
      ];
      J.move_selection = [
        0
        5
      ];
      K.move_selection = [
        0
        (-5)
      ];
      L.move_selection = [
        5
        0
      ];
      c = "cancel_selection";
      o = "border_mode";
    };
  };
}
