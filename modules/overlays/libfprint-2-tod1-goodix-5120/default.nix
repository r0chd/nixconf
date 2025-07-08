{ libfprint }:
libfprint.overrideAttrs (oa: {
  pname = "libfprint-goodixtls-51x0";
  version = "";

  src = fetchFromGitHub {
    owner = "TheWeirdDev";
    repo = "libfprint";
  };
})
