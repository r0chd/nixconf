{ conf, pkgs, inputs, lib }: {
  options = {
    enable = lib.mkEnableOption "Enable terminal emulator";
    program =
      lib.mkOption { type = lib.types.enum [ "kitty" "foot" "ghostty" ]; };
  };

  imports = [
    (import ./kitty { inherit conf lib; })
    (import ./foot { inherit conf lib; })
    (import ./ghostty { inherit pkgs inputs conf lib; })
  ];
}
