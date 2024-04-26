{
  lib,
  stdenv,
  cmake,
  jrl-cmakemodules,
  boost,
  python3Packages,
  withPython ? false,
}:
stdenv.mkDerivation {
  pname = "example-adder";
  version = "4.0.2";

  src = ./.;

  propagatedBuildInputs = [ boost ];

  buildInputs = lib.optional withPython [
    python3Packages.python
    python3Packages.boost
  ];

  nativeBuildInputs = [
    cmake
    jrl-cmakemodules
  ];

  cmakeFlags = [ (lib.cmakeBool "BUILD_PYTHON_INTERFACE" withPython) ];

  outputs = [
    "dev"
    "out"
  ];

  doCheck = true;
}
