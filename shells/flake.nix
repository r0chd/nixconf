{
  description = "Seto - hardware accelerated keyboard driven screen selection tool";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    zls.url = "github:zigtools/zls";
    zig.url = "github:mitchellh/zig-overlay";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    zls,
    zig,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        devShells.zig = import ./zig.nix {inherit pkgs system zls zig;};
        devShells.c = import ./c.nix {inherit pkgs;};
        devShells.rust = import ./rust.nix {inherit pkgs;};
      }
    );
}
