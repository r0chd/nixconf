{ lib, ... }: {
  options.wallpaper = {
    enable = lib.mkEnableOption "Enable wallpaper";
    program = lib.mkOption { type = lib.types.enum [ "ruin" ]; };
    path = lib.mkOption {
      type = lib.types.str;
    }; # TODO: make it into path once I rewrite ruin
  };

  imports = [ ./ruin ];
}
