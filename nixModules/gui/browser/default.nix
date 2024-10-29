{ conf, inputs, pkgs, lib, std }: {
  options.browser = {
    enable = lib.mkEnableOption "Enable browser";
    program = lib.mkOption {
      type = lib.types.enum [ "ladybird" "firefox" "chromium" "qutebrowser" ];
    };
  };

  imports = [
    (import ./firefox { inherit conf inputs pkgs lib std; })
    (import ./qutebrowser { inherit conf lib std; })
    (import ./chromium { inherit conf lib pkgs; })
    (import ./ladybird { inherit conf lib; })
  ];
}
