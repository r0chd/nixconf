{ conf, std, pkgs, inputs, lib }: {
  options.wallpaper = {
    enable = lib.mkEnableOption "Enable wallpaper";
    program = lib.mkOption { type = lib.types.enum [ "ruin" ]; };
    path = lib.types.string; # TODO: make it into path once I rewrite ruin
  };

  imports = [ (import ./ruin { inherit pkgs inputs conf std lib; }) ];
}
