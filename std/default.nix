{ username, hostname, lib, }: {
  conversions = import ./conversions.nix { inherit lib; };
  dirs = import ./dirs.nix { inherit username hostname; };
  math = import ./math.nix { inherit lib; };
}
