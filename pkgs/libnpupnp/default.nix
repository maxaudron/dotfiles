{ fetchgit, lib, stdenv, autoreconfHook, pkg-config, curl, libmicrohttpd, expat
}:

stdenv.mkDerivation rec {
  pname = "libnpupnp";
  version = "4.2.1";

  outputs = [ "out" "dev" ];

  src = fetchgit {
    url = "https://framagit.org/medoc92/npupnp";
    rev = "${pname}-v${version}";
    hash = "sha256-4qMtWOkLANisjzQ3cWjLNC8qQrdny1Adc093Zc+F1fE=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ curl libmicrohttpd expat ];

  meta = {
    description =
      "A C++ base UPnP library, derived from Portable UPnP, a.k.a libupnp";

    license = lib.licenses.bsd3;

    homepage = "https://framagit.org/medoc92/npupnp";
    platforms = lib.platforms.unix;
  };
}
