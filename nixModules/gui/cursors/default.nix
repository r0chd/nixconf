{
  conf,
  pkgs,
}: {
  environment.systemPackages = [
    (pkgs.callPackage ./bibata_hyprcursor {})
    #    (
    #      if conf ? cursor && conf.cursor == "bibata_hyprcursor"
    #      then [(import ./bibata_hyprcursor)]
    #      else []
    #    )
  ];
}
