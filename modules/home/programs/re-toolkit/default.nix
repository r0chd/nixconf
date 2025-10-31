{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.programs.re-toolkit;
  ghidraConfigPath = "ghidra/${pkgs.ghidra.distroPrefix}";
in
{
  options.programs.re-toolkit = {
    enable = lib.mkEnableOption "re-toolkit";
  };
  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.pince
      (pkgs.ghidra.withExtensions (p: builtins.attrValues { inherit (p) ret-sync; }))
      (pkgs.lutris.override {
        extraLibraries = pkgs: [
          # List library dependencies here
        ];
        extraPkgs = pkgs: [
          # List package dependencies here
        ];
      })
    ];

    xdg.configFile."${ghidraConfigPath}/preferences".text = ''
      GhidraShowWhatsNew=false
      SHOW.HELP.NAVIGATION.AID=true
      SHOW_TIPS=false
      TIP_INDEX=0
      G_FILE_CHOOSER.ShowDotFiles=true
      USER_AGREEMENT=ACCEPT
      LastExtensionImportDirectory=${config.home.homeDirectory}/.config/ghidra/scripts/
      LastNewProjectDirectory=${config.home.homeDirectory}/.config/ghidra/repos/
      ViewedProjects=
      RecentProjects=
    '';

    systemd.user.tmpfiles.rules = [
      "d %h/.config/${ghidraConfigPath} 0700 - - -"
      "L+ %h/.config/ghidra/latest - - - - %h/.config/${ghidraConfigPath}"
      "d %h/.config/ghidra/scripts 0700 - - -"
      "d %h/.config/ghidra/repos 0700 - - -"
    ];
  };
}
