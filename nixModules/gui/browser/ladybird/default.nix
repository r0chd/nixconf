{ conf, lib }: {
  config =
    lib.mkIf (conf.browser.enable && conf.browser.program == "ladybird") {
      programs.ladybird.enable = true;
      environment.shellAliases.ladybird = "Ladybird";
    };
}
