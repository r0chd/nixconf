{ conf, inputs, pkgs, lib, }: {
  options.browser = {
    enable = lib.mkEnableOption "Enable browser";
    program = lib.mkOption {
      type = lib.types.enum [ "ladybird" "firefox" "chromium" "qutebrowser" ];
    };
  };

  imports = [
    (import ./firefox { inherit conf inputs pkgs lib; })
    (import ./qutebrowser { inherit conf lib; })
    (import ./chromium { inherit conf lib pkgs; })
    (import ./ladybird { inherit conf lib; })
  ];
}
