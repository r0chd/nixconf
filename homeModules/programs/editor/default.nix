{ lib, config, ... }:
{
  imports = [
    ./nvim
    ./nano
    ./helix
  ];

  options.editor = lib.mkOption {
    type = lib.types.enum [
      "nvim"
      "nano"
      "hx"
    ];
  };

  config.home = {
    sessionVariables.EDITOR = config.editor;
    shellAliases = {
      vi = config.editor;
      vim = config.editor;
      nvim = config.editor;
      nano = config.editor;
      hx = config.editor;
    };
  };
}
