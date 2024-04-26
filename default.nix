{
  boost,
  cmake,
  doxygen,
  lib,
  stdenv,
  jrl-cmakemodules,
  pkg-config,
  python3Packages,
  pythonSupport ? false,
}:
stdenv.mkDerivation {
  pname = "example-adder";
  version = "4.0.2";

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

  nativeBuildInputs = [
    cmake
    doxygen
    jrl-cmakemodules
    pkg-config
  ];

  buildInputs = lib.optionals pythonSupport [
    python3Packages.python
    python3Packages.boost
  ];

  checkInputs = lib.optional (!pythonSupport) boost;

  cmakeFlags = [ (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport) ];

  outputs = [
    "dev"
    "doc"
    "out"
  ];

  doCheck = true;
}
