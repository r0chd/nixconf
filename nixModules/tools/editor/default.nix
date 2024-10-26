{ pkgs, inputs, conf, lib }: {
  options.editor = lib.mkOption { type = lib.types.enum [ "nvim" "nano" ]; };

  config = {
    environment.variables.EDITOR = conf.editor;
    programs.nano.enable = lib.mkDefault false;
  };

  imports = [
    (import ./nvim { inherit pkgs inputs conf lib; })
    (import ./nano { inherit conf lib; })
  ];
}
