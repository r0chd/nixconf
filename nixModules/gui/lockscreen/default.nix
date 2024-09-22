{conf}: {
  imports =
    []
    ++ (
      if conf ? lockscreen && conf.lockscreen == "hyprlock"
      then [(import ./hyprlock {inherit conf;})]
      else []
    );
}
