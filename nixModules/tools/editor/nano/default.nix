{ conf, lib }: {
  config = lib.mkIf (conf.editor == "nano") { programs.nano.enable = true; };
}
