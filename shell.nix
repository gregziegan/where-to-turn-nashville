{ sources ? null }:
let
  deps = import ./nix/deps.nix { inherit sources; };
  inherit (deps) pkgs;
  inherit (pkgs) lib stdenv;
  caBundle = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";

in pkgs.mkShell {
  name = "where-to-run-nashville";
  buildInputs = deps.shellInputs ++ [
    pkgs.nodejs
  ];
  shellHook = ''
    # A pure nix shell breaks SSL for git and nix tools which is fixed by setting
    # the path to the certificate bundle.
    export SSL_CERT_FILE=${caBundle}
    export NIX_SSL_CERT_FILE=${caBundle}
    set -o allexport; source .env; set +o allexport
    set -o allexport; source .env.dev; set +o allexport
  '';
}
