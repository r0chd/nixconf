{
  hostname,
  lib,
}:
{
  conversions = import ./conversions.nix { inherit lib; };
  dirs = import ./dirs.nix { inherit hostname; };
  math = import ./math.nix { inherit lib; };
}
