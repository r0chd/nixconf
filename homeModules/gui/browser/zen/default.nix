{
  inputs,
  pkgs,
  config,
  lib,
  ...
}:
{
  config = lib.mkIf (config.browser.program == "zen") {
    home.packages = with pkgs; [ inputs.zen-browser.packages.${system}.default ];
    impermanence.persist.directories = [
      ".cache/zen"
      ".zen"
    ];
  };
}
