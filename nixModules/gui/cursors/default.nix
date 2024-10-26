{ conf, pkgs, lib, }: {
  options.cursor = {
    enable = lib.mkEnableOption "Enable cursor theme";
    name = lib.mkOption { type = lib.types.enum [ "bibata" ]; };
    size = lib.mkOption { type = lib.types.int; };
    themeName = lib.mkOption { type = lib.types.string; };
  };

  imports = [ (import ./bibata { inherit pkgs lib conf; }) ];
}
