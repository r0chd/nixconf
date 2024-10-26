{ conf, std, pkgs, inputs, lib }: {
  options.statusBar = {
    enable = lib.mkEnableOption "Enable status bar";
    program = lib.mkOption { type = lib.types.enum [ "waystatus" ]; };
  };

  imports = [ (import ./waystatus { inherit conf std pkgs inputs lib; }) ];
}
