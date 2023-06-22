{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, rustPlatform
}:

stdenv.mkDerivation rec {
  pname = "weechat-matrix-rs";
  version = "20220804";

  src = fetchFromGitHub {
    owner = "poljar";
    repo = pname;
    rev = "ca23e1745e6e2ba235550360e1def1457e2f3857";
    sha256 = lib.fakeSha256;
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    sha256 = lib.fakeSha256;
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustPlatform.rust.cargo
    rustPlatform.rust.rustc
    rustPlatform.bindgenHook
  ];

  WEECHAT_BUNDLED = "false";
  LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
  BINDGEN_EXTRA_CLANG_ARGS = "-isystem ${pkgs.llvmPackages.libclang.lib}/lib/clang/${lib.getVersion pkgs.clang}/include";
  OPENSSL_STATIC = 1;
  OPENSSL_DIR = "${pkgs.pkgsStatic.openssl}";
  OPENSSL_LIB_DIR = "${pkgs.pkgsStatic.openssl.out}/lib";
  OPENSSL_INCLUDE_DIR = "${pkgs.pkgsStatic.openssl.dev}/include";
}
