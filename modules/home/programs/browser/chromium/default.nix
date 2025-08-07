{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.chromium;
in
{
  config = lib.mkIf cfg.enable {
    programs.chromium = {
      #package = pkgs.ungoogled-chromium;
      extensions = [
        { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
        { id = "gnphfcibcphlpedmaccolafjonmckcdn"; } # Extension Switch
        { id = "fihnjjcciajhdojfnbdddfaoknhalnja"; } # I don't care about cookies
        { id = "mnjggcdmjocbbbhaepdhchncahnbgone"; } # SponsorBlock for YouTube - Skip Sponsorships
        { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # uBlock Origin Lite
        { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # Vimium
      ];
      commandLineArgs = [
        "--ozone-platform-hint=auto"
        "--ozone-platform=wayland"
        "--enable-features=Vulkan"
        "--force-dark-mode"
        "--enable-features=TouchpadOverscrollHistoryNavigation,WebUIDarkMode"
        "--extension-mime-request-handling=always-prompt-for-install"
      ];
    };

    home.persist.directories = [
      ".cache/chromium"
      ".config/chromium/Default"
    ];
  };
}
