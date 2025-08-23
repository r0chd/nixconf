{ lib, ... }:
{
  imports = [ ./nixGLWrap ];

  nixpkgs.config = {
    # these look fun but may cause mass rebuilds (lmfao)
    # https://nixos.org/manual/nixpkgs/stable/#opt-enableParallelBuildingByDefault
    # https://nixos.org/manual/nixpkgs/stable/#opt-replaceBootstrapFiles
    warnUndeclaredOptions = true;
    allowAliases = false;
    allowVariants = false;
    checkMeta = true;
    allowNonSource = false;
    allowNonSourcePredicate =
      pkg:
      !(lib.any (
        p:
        !p.isSource
        && p != lib.sourceTypes.binaryFirmware
        && (
          !builtins.elem (lib.getName pkg) [
            "go"
            "cargo-bootstrap"
            "rustc-bootstrap-wrapper"
            "rustc-bootstrap"
            "dart"
            "google-cloud-sdk"
            "temurin-bin"
            "slack"
          ]
        )
      ) (lib.toList pkg.meta.sourceProvenance));
  };
}
