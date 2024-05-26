{
  term,
  inputs,
  username,
  ...
}: {
  imports = [
    (import ./home.nix {inherit inputs username term;})
  ];

  security.polkit.enable = true;
}
