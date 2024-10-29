{ conf, pkgs, lib, std, }: {
  imports = [
    (import ./ssh { inherit conf std lib; })
    (import ./wireless { inherit pkgs conf lib; })
  ];
}
