{ sources ? null }:
with builtins;

let
  sources_ = if (sources == null) then import ./sources.nix else sources;
  pkgs = import sources_.nixpkgs {};
in rec {
  inherit pkgs;

  # Various tools for log files, deps management, running scripts and so on
  shellTools = 
  [
    pkgs.jq
  ];

  backendTools =
  [
    pkgs.nodejs
  ];

  frontendTools =
  [
    pkgs.elmPackages.elm
    pkgs.elmPackages.elm-test-rs
    pkgs.elmPackages.elm-format
    pkgs.elmPackages.elm-optimize-level-2
    pkgs.elmPackages.elm-review
  ];

  # Needed for a development nix shell
  shellInputs = shellTools ++
    backendTools ++
    frontendTools;

}

