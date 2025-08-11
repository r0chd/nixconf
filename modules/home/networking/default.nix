{ lib, ... }:
let
  inherit (lib) types;
in
{
  imports = [ ./ssh ];

  options.networking.hostName = lib.mkOption {
    type = types.str;
  };
}
