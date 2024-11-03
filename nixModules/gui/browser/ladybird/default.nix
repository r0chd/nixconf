{ config, lib, ... }: {
  config =
    lib.mkIf (config.browser.enable && config.browser.program == "ladybird") {
      programs.ladybird.enable = true;
      environment.shellAliases.ladybird = "Ladybird";
    };
}
