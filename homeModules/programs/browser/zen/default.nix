{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.zen;
in
{
  options.programs.zen.enable = lib.mkEnableOption "zen";

  imports = [ inputs.zen-browser.homeModules.default ];

  config = lib.mkIf cfg.enable {
    programs.zen-browser = {
      enable = true;
      policies = {
        DisableAppUpdate = true;
        DisableTelemetry = true;
        AutofillAddressEnabled = false;
        AutofillCreditCardEnabled = false;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DontCheckDefaultBrowser = true;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
      };
      profiles."${config.home.username}" = {
        extensions = {
          force = true;
          packages = with inputs.firefox-addons.packages.${pkgs.system}; [
            keepassxc-browser
            ublock-origin
            sponsorblock
            darkreader
            vimium
            youtube-shorts-block
          ];
        };
      };
    };

    home = {
      persist.directories = [
        ".cache/zen"
        ".zen"
      ];
    };
  };
}
