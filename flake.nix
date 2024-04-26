{
  description = "This is an example project, to show how to use Gepetto's tools";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        example-adder = pkgs.callPackage ./default.nix { };
        py-example-adder = pkgs.python3Packages.toPythonModule (
          example-adder.override { withPython = true; }
        );
      in
      {
        packages = {
          inherit example-adder py-example-adder;
          default = py-example-adder;
        };
        devShells = {
          compiled = pkgs.mkShell { packages = [ (pkgs.python3.withPackages (ps: [ py-example-adder ])) ]; };
          default = pkgs.mkShell { inputsFrom = [ py-example-adder ]; };
        };
      }
    );
}
