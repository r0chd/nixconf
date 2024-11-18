{ config, lib, ... }:
{
  config = lib.mkIf (config.browser.enable && config.browser.program == "qutebrowser") {
    impermanence.persist.directories = [
      ".cache/qutebrowser"
      ".local/share/qutebrowser"
    ];
    programs.qutebrowser = {
      enable = true;
      searchEngines = {
        DEFAULT = "https://search.brave.com/search?q={}";
        aw = "https://wiki.archlinux.org/?search={}";
        aur = "https://aur.archlinux.org/packages/?O=0&K={}";
        yt = "https://www.youtube.com/results?search_query={}";
        nix = "https://search.nixos.org/packages?query={}";
      };
      settings = {
        "colors.webpage.preferred_color_scheme" = "dark";
        "colors.webpage.darkmode.enabled" = true;
        "colors.webpage.darkmode.algorithm" = "lightness-cielab";
        "colors.webpage.darkmode.threshold.foreground" = 150;
        "colors.webpage.darkmode.threshold.background" = 100;
        "colors.webpage.darkmode.policy.images" = "smart-simple";
        "content.javascript.clipboard" = "access-paste";
        "content.user_stylesheets" = [ ];
        "scrolling.smooth" = true;
        "url.start_pages" = [ "https://search.brave.com" ];
      };
    };
  };
}
