{
  inputs,
  ...
}:
{
  imports = [
    inputs.seto.homeManagerModules.default
    inputs.seto.homeManagerModules.stylix
  ];

  programs.seto = {
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
