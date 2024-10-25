{conf}: {
  imports =
    []
    ++ (
      if conf ? notifications && conf.notifications == "mako"
      then [(import ./mako {inherit conf;})]
      else []
    );
}
