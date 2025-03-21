{ lib, config, ... }:
{
  imports = [
    ./nvim
    ./nano
    ./helix
  ];

  options.programs.editor = lib.mkOption {
    type = lib.types.enum [
      "nvim"
      "nano"
      "hx"
    ];
  };

  config.home = {
    sessionVariables.EDITOR = config.programs.editor;
    shellAliases = {
      vi = config.programs.editor;
      vim = config.programs.editor;
      nvim = config.programs.editor;
      nano = config.programs.editor;
      hx = config.programs.editor;
    };
  };
}
