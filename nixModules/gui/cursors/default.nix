{
  conf,
  pkgs,
  lib,
}: {
  imports =
    []
    ++ (
      if conf ? cursor && conf.cursor == "bibata"
      then [(import ./bibata {inherit pkgs;})]
      else []
    );
}
