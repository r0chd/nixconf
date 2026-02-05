{ ... }:
{
  imports = [
    # TODO
    # ./require-limits-requests.nix
    #./require-labels.nix
    ./check-deprecated-apis.nix
    ./disallow-latest-tag.nix
  ];
}
