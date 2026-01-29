{ lib, ... }:
let
  inherit (lib) types;
in
{
  imports = [
    ./ssh.nix
    ./gpg.nix
  ];

  options.networking.hostName = lib.mkOption {
    type = types.str;
  };
}
