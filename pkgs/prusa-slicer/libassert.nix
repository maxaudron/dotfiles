{
  stdenv,
  fetchFromGitHub,

  cmake,
  pkg-config,

  cpptrace,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libassert";
  version = "2.2.1";
  # Build with clang even on Linux, because GCC uses absolutely obscene amounts of memory
  # on this particular code base (OOM with 32GB memory and --cores 16 on GCC, succeeds
  # with --cores 32 on clang).
  src = fetchFromGitHub {
    owner = "jeremy-rifkin";
    repo = "libassert";
    hash = "sha256-ognudQ3NgpYxiDEucbIRWYQPs0XLRUQwg1eMxJm+aPs=";
    rev = "v${finalAttrs.version}";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    cpptrace
  ];

  cmakeFlags = [
    "-DLIBASSERT_USE_EXTERNAL_CPPTRACE=ON"
  ];
})
