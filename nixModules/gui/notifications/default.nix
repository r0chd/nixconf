{conf}: {
  imports = let
    inherit (conf) username;
  in
    []
    ++ (
      if conf ? notifications && conf.notifications == "mako"
      then [(import ./mako {inherit username;})]
      else []
    );
}
