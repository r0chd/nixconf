{
  config,
  pkgs,
  username,
}: {
  environment.systemPackages = with pkgs; [cachix];

  #TODO: make it but pure
  #home-manager.users."${username}".home.file.".config/cachix/cachix.dhall".text = ''
  #  { authToken =
  #      "${builtins.readFile config.sops.secrets.cachix.path}"
  #  , hostname = "https://cachix.org"
  #  , binaryCaches = [] : List { name : Text, secretKey : Text }
  #  }
  #'';
}
