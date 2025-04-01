{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems =
        function:
        nixpkgs.lib.genAttrs systems (
          system:
          let
            pkgs = import nixpkgs { inherit system; };
          in
          function pkgs
        );
    in
    {
      devShells = forAllSystems (pkgs: {
        default =
          with pkgs;
          mkShell {
            buildInputs = [
              nixd
              php
              phpactor
            ];
          };
      });
    };
}
