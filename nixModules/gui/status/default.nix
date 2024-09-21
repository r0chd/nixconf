{
  conf,
  std,
  pkgs,
  inputs,
}: {
  imports =
    []
    ++ (
      if conf ? statusBar && conf.statusBar == "waystatus"
      then [(import ./waystatus {inherit conf std pkgs inputs;})]
      else []
    );
}
