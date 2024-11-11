{ inputs, pkgs, config, lib, ... }: {
  config = lib.mkIf (config.browser.program == "zen") {
    environment.systemPackages = with pkgs;
      [ inputs.zen-browser.packages.${system}.default ];

    impermanence.persist-home.directories = [ ".cache/zen" ".zen" ];
  };
}
