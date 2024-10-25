{
  pkgs,
  system,
  zig,
  zls,
}:
pkgs.mkShell {
  packages = [
    zls.packages.${system}.default
    zig.packages.${system}."0.13.0"
  ];
}
