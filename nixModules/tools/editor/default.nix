{ pkgs, inputs, config, lib, std, username, ... }: {
  options.editor = lib.mkOption { type = lib.types.enum [ "nvim" "nano" ]; };

  config = {
    environment.variables.EDITOR = config.editor;
    programs.nano.enable = lib.mkDefault false;
  };

  imports = [
    (import ./nvim {
      inherit pkgs inputs lib std username;
      conf = config;
    })
    (import ./nano {
      inherit lib;
      conf = config;
    })
  ];
}
