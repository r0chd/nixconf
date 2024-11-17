{ config, lib, ... }: {
  options.editor = lib.mkOption { type = lib.types.enum [ "nvim" "nano" ]; };

  config = {
    environment.variables.EDITOR = config.editor;
    programs.nano.enable = lib.mkDefault false;
  };

  imports = [ ./nvim ./nano ];
}
