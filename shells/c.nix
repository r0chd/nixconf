{pkgs}:
pkgs.mkShell {
  packages = with pkgs; [
    clang-tools
    valgrind
  ];
}
