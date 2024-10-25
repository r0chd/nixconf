{
  conf,
  pkgs,
  std,
}: {
  imports =
    []
    ++ (
      if conf ? lockscreen && conf.lockscreen == "hyprlock"
      then [(import ./hyprlock {inherit conf pkgs std;})]
      else []
    );
}
