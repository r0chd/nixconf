{ lib, ... }:
{
  options.cursor = {
    enable = lib.mkEnableOption "Enable cursor theme";
    name = lib.mkOption {
      type = lib.types.enum [
        "bibata"
        "banana"
      ];
    };
    size = lib.mkOption { type = lib.types.int; };
    themeName = lib.mkOption { type = lib.types.str; };
  };

  imports = [
    ./bibata
    ./banana
  ];
}
