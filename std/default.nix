{ lib }:
{
  conversions = import ./conversions.nix { inherit lib; };
  dirs = import ./dirs.nix { };
  math = import ./math.nix { inherit lib; };
}
