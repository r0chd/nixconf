{
  conf,
  pkgs,
  lib,
}: {
  environment.systemPackages =
    []
    ++ (lib.optional (conf ? cursor && conf.cursor == "bibata") (pkgs.callPackage ./bibata {}));
}
