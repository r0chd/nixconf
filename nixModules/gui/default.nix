{ conf, pkgs, inputs, lib, std, }: {
  imports = [
    (import ./browser { inherit conf inputs pkgs lib; })
    (import ./terminal { inherit conf inputs pkgs lib; })
    (import ./cursors { inherit conf pkgs lib; })
    (import ./status { inherit conf std pkgs inputs lib; })
    (import ./notifications { inherit conf lib; })
    (import ./lockscreen { inherit conf std lib; })
    (import ./wallpaper { inherit conf std pkgs inputs lib; })
    (import ./launcher { inherit conf lib; })
  ];
}
