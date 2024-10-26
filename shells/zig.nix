{ pkgs, zig, zls, }:
pkgs.mkShell {
  packages = with pkgs; [
    zls.packages.${system}.default
    zig.packages.${system}."0.13.0"
    zigfmt
  ];
}
