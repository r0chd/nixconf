{
  inputs,
  config,
  ...
}:
{
  imports = [
    ./environment
    ./services
    ./security
    ./nix
  ];

  nixpkgs.overlays = import ../overlays inputs config ++ import ../lib config;
  environment.etc."sysctl.d/60-apparmor-namespace.conf".text = ''
    kernel.apparmor_restrict_unprivileged_userns=0
  '';
}
