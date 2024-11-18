{ lib, config, ... }:
{
  options.editor = lib.mkOption {
    type = lib.types.enum [
      "nvim"
      "nano"
    ];
  };

  config = {
    home.sessionVariables.EDITOR = config.editor;
  };

  imports = [
    ./nvim
    ./nano
  ];
}
