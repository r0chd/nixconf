{ lib, ... }:
{
  options.browser = {
    enable = lib.mkEnableOption "Enable browser";
    program = lib.mkOption {
      type = lib.types.enum [
        "ladybird"
        "firefox"
        "chromium"
        "qutebrowser"
        "zen"
      ];
    };
  };

  imports = [
    ./firefox
    ./qutebrowser
    ./chromium
    ./ladybird
    ./zen
  ];
}
