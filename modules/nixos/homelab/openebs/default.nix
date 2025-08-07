{ pkgs, ... }:
{
  config.services.k3s.autoDeployCharts.openebs = {
    targetNamespace = "openebs-system";
    package = pkgs.fetchurl {
      url = "https://openebs.github.io/openebs/openebs-4.3.2.tgz";
      sha256 = "sha256-Wbx2n6YHiIHTNlKti6MeJyiKoRFJ5TyM0fgnZai+UfU=";
    };
    createNamespace = true;

    values = {
      localpv-provisioner.enabled = false;
      jiva.enabled = false;
      cstor.enabled = false;
      ndm.enabled = true;
      mayastor.enabled = true;
    };
  };
}
