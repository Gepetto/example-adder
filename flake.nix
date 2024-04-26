{
  description = "This is an example project, to show how to use Gepetto's tools";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = inputs.nixpkgs.lib.systems.flakeExposed;
      perSystem =
        { pkgs, self', ... }:
        {
          apps.default = {
            type = "app";
            program = pkgs.python3.withPackages (_: [ self'.packages.default ]);
          };
          devShells.default = pkgs.mkShell { inputsFrom = [ self'.packages.default ]; };
          packages = {
            default = self'.packages.py-example-adder;
            example-adder = pkgs.callPackage ./. { };
            py-example-adder = pkgs.python3Packages.toPythonModule (
              self'.packages.example-adder.override { pythonSupport = true; }
            );
          };
        };
    };
}
