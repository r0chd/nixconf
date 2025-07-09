{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.zen-browser;
in
{
  imports = [ inputs.zen-browser.homeModules.default ];

  programs.zen-browser = {
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

    profiles.${config.home.username} = {
      userChrome = pkgs.runCommand "userChrome.css" { } ''
        cat ${
          pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/catppuccin/zen-browser/refs/heads/main/themes/Frappe/Lavender/userChrome.css";
            sha256 = "06cy1yrhfbnhsfacm48n817b4h3p1kgdw7aj6469sqci3wglyqwy";
          }
        } > $out
        echo ':root {
          --zen-main-browser-background: rgba(26,27,38,0.8) !important;
        }' >> $out
      '';

      userContent = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/zen-browser/refs/heads/main/themes/Frappe/Lavender/userContent.css";
        sha256 = "1xiabsqsm7x10q2kx6c5fd2nfii96c0hffbpx34h9pivx52f8vhz";
      };
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "zen.welcome-screen.seen" = true;
        "zen.view.show-newtab-button-border-top" = true;
        "zen.view.show-newtab-button-top" = false;

        "extensions.autoDisableScopes" = 0;
        "extensions.webextensions.restrictedDomains" = "";
        "browser.startup.homepage" = "https://ironlungx.github.io/Bento/";
        "browser.search.defaultenginename" = "Duckduckgo";
        "browser.aboutConfig.showWarning" = false;
        "browser.startup.page" = 1;
        "browser.download.useDownloadDir" = true;
      };
      search = {
        force = true;
        engines = {
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };

          "My NixOS" = {
            urls = [ { template = "https://mynixos.com/search?q={searchTerms}"; } ];
            icon = "https://mynixos.com/favicon.ico";
            definedAliases = [ "@mynixos" ];
          };

          "NixOS Wiki" = {
            urls = [ { template = "https://nixos.wiki/index.php?search={searchTerms}"; } ];
            icon = "https://nixos.wiki/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "@nw" ];
          };

          "Duckduckgo" = {
            urls = [ { template = "https://duckduckgo.com/?q={searchTerms}"; } ];
            icon = "https://duckduckgo.com/favicon.png";
            definedAliases = [ "@dg" ];
          };

          "Youtube" = {
            urls = [ { template = "https://youtube.com/search?q={searchTerms}"; } ];
            icon = "https://youtube.com/favicon.ico";
            definedAliases = [ "@yt" ];
          };

          bing.metaData.hidden = true;
          ebay.metaData.hidden = true;
          google.metaData.alias = "@g";
        };
        default = "ddg";
      };

      extensions = {
        force = true;
        packages = with inputs.firefox-addons.packages.${pkgs.system}; [
          ublock-origin
          sponsorblock
          darkreader
          vimium
          youtube-shorts-block
          stylus
        ];
      };
      settings."uBlock0@raymondhill.net".settings = {
        selectedFilterLists = [
          "ublock-filters"
          "ublock-badware"
          "ublock-privacy"
          "ublock-unbreak"
          "ublock-quick-fixes"
        ];
      };
    };
  };

  home = lib.mkIf cfg.enable {
    persist.directories = [
      ".cache/zen"
      ".zen"
    ];
  };
}
