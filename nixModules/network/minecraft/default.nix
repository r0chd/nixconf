{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.nix-minecraft.nixosModules.minecraft-servers];
  nixpkgs.overlays = [inputs.nix-minecraft.overlay];

  services.minecraft-servers = {
    enable = true;
    eula = true;

    servers = {
      server1 = {
        enable = true;
        package = pkgs.fabricServers.fabric-1_21;

        serverProperties = {};
        whitelist = {};

        symlinks =
          #let
          # modpack = pkgs.fetchPackwizModpack {
          #   url = "";
          #   packHash = "";
          # };
          #in
          {
            #"mods" = "${modpack}/mods";
            "mods" = pkgs.linkFarmFromDrvs "mods" (builtins.attrValues {
              Starlight = builtins.fetchurl {url = "";};
            });
          };
      };
    };
  };
}
