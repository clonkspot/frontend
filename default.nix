{ buildNpmPackage }:

buildNpmPackage {
  pname = "clonkspot-frontend";
  version = "0.0.0";

  src = ./.;

  npmDepsHash = "sha256-XIcykB67y9fXXLo/TJXlx+aD0FTbJB0uRMPcIO7/zpw=";
}
