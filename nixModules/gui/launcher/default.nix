{conf}: {
  imports =
    []
    ++ (
      if conf ? launcher && conf.launcher == "fuzzel"
      then [(import ./fuzzel {inherit conf;})]
      else []
    );
}
