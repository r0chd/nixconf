{ inputs, pkgs }:
pkgs.mkShell {
  packages = with pkgs; [
    inputs.zls.packages.${system}.default
    inputs.zig.packages.${system}."0.13.0"
    zig-fmt
  ];
}
