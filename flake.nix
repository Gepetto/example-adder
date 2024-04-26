{
  description = "This is an example project, to show how to use Gepetto's tools";

  inputs.gepetto.url = "github:gepetto/nix";

  outputs =
    inputs:
    inputs.gepetto.lib.mkFlakoboros inputs (
      { lib, ... }:
      {
        pyOverrideAttrs.example-adder = {
          src = lib.fileset.toSource {
            root = ./.;
            fileset = lib.fileset.unions [
              ./CMakeLists.txt
              ./include
              ./package.xml
              ./python
              ./src
              ./tests
            ];
          };
        };
      }
    );
}
