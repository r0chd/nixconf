{ lib, ... }:
{
  options.colorscheme = {
    name = lib.mkOption { type = lib.types.enum [ "catppuccin" ]; };
    text = lib.mkOption { type = lib.types.str; };
    accent1 = lib.mkOption { type = lib.types.str; };
    accent2 = lib.mkOption { type = lib.types.str; };
    background1 = lib.mkOption { type = lib.types.str; };
    background2 = lib.mkOption { type = lib.types.str; };
    error = lib.mkOption { type = lib.types.str; };
    special = lib.mkOption { type = lib.types.str; };
    inactive = lib.mkOption { type = lib.types.str; };
    warn = lib.mkOption { type = lib.types.str; };
  };

  config.colorscheme = {
    text = "FFFFFF";
    accent1 = "C5A8EB";
    accent2 = "C9CBFF";
    background1 = "170E1F";
    background2 = "140F21";
    error = "CA8080";
    special = "A6E3A1";
    inactive = "1E1E2E";
    warn = "DD7878";
  };
}
