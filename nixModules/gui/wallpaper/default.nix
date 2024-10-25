{
  conf,
  std,
  pkgs,
  inputs,
}: {
  imports =
    []
    ++ (
      if conf ? wallpaper && conf.wallpaper ? program && conf.wallpaper.program == "ruin"
      then [(import ./ruin {inherit pkgs inputs conf std;})]
      else []
    );
}
