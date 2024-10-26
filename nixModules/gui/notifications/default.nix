{ conf, lib }: {
  options.notifications = {
    enable = lib.mkEnableOption "Enable notification daemon";
    program = lib.mkOption { type = lib.types.enum [ "mako" ]; };
  };
  imports = [ (import ./mako { inherit conf lib; }) ];
}
