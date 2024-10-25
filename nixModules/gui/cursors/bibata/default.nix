{pkgs}: {
  environment.systemPackages = [(pkgs.callPackage ./hyprcursor.nix {})];
}
