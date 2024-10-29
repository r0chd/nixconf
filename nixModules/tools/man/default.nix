{ pkgs, lib, conf }: {
  options.man.enable = lib.mkEnableOption "Enable man pages";

  config = lib.mkIf conf.man.enable {
    documentation.dev.enable = true;
    environment.systemPackages = with pkgs; [ man-pages man-pages-posix ];
  };
}
