{ lib, ... }:
{
  options.programs.browser = {
    enable = lib.mkEnableOption "Enable browser";
    variant = lib.mkOption {
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
