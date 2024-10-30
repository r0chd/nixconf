{ config, std, pkgs, inputs, lib, username, ... }: {
  options.statusBar = {
    enable = lib.mkEnableOption "Enable status bar";
    program = lib.mkOption { type = lib.types.enum [ "waystatus" ]; };
  };

  imports = [
    (import ./waystatus {
      inherit std pkgs inputs lib username;
      conf = config;
    })
  ];
}
