{
  conf,
  pkgs,
}: {
  imports =
    []
    ++ (
      if conf ? lockscreen && conf.lockscreen == "hyprlock"
      then [(import ./hyprlock {inherit conf pkgs;})]
      else []
    );
}
