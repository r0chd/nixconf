{ lib, ... }:
{
  imports = [
    ./tmux
    ./zellij
  ];

  options.programs.multiplexer = {
    enable = lib.mkEnableOption "Multiplexer";
    variant = lib.mkOption {
      type = lib.types.enum [
        "tmux"
        "zellij"
      ];
    };
  };

}
