{ pkgs, lib, config, ... }: {
  options.man.enable = lib.mkEnableOption "Enable man pages";

  config = lib.mkIf config.man.enable {
    documentation.dev.enable = true;
    environment.systemPackages = with pkgs; [ man-pages man-pages-posix ];
  };
}
