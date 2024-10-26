{ conf, pkgs, lib, std, }: {
  imports = [
    (import ./ssh { inherit conf std; })
    (import ./wireless { inherit pkgs conf lib; })
  ];
}
