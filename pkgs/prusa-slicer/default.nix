{
  stdenv,
  fetchFromGitHub,

  cmake,
  pkg-config,
  autoconf,
  boost,

  onetbb,
  nlopt,
  glew,
  cereal,
  fmt,
  tracy,
  eigen,
  glfw3,
  SDL2,
  catch2_3,
  tl-expected,
  spdlog,
  libassert,
  cpptrace,
  nanosvg,
  qhull,
  prusa-fdm-mixer,
  cgal,
  openssl,
  openvdb,
  c-blosc,
  libbgcode,
  heatshrink,
  lua,
  sol2,
  opencascade-occt_7_6_1,
  cli11,
  yoga,
  nlohmann_json,
  pugixml,
  rapidyaml,
  magic-enum,
  range-v3,
  libdeflate,
  curl,
  wxwidgets_3_3,

  libGLU,
  gtk3,
  dbus,
  webkitgtk_4_1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "prusa-slicer-3";
  version = "3.0.0-alpha11";
  # Build with clang even on Linux, because GCC uses absolutely obscene amounts of memory
  # on this particular code base (OOM with 32GB memory and --cores 16 on GCC, succeeds
  # with --cores 32 on clang).
  src = fetchFromGitHub {
    owner = "prusa3d";
    repo = "PrusaSlicer";
    hash = "sha256-U+5CYJ6mykZA37uqPKeDyKcQfTmgG1BCRV8dVhLWTHs=";
    rev = "version_${finalAttrs.version}";
  };

  patches = [ ./boost_no_system.patch ];

  postPatch = ''
    substituteInPlace src/slic3r-platform-wx/CMakeLists.txt \
      --replace-fail 'find_package(wxWidgets 3.3 CONFIG' 'find_package(wxWidgets 3.3 MODULE'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    autoconf
  ];

  buildInputs = [
    boost

    onetbb
    nlopt
    glew
    cereal
    fmt
    tracy
    eigen
    glfw3
    SDL2
    catch2_3
    tl-expected
    spdlog
    libassert
    cpptrace
    nanosvg
    qhull
    prusa-fdm-mixer
    cgal
    openssl
    openvdb
    c-blosc
    libbgcode
    heatshrink
    lua
    sol2
    opencascade-occt_7_6_1
    cli11
    yoga
    nlohmann_json
    pugixml
    rapidyaml
    magic-enum
    range-v3
    libdeflate
    curl
    wxwidgets_3_3

    libGLU
    gtk3
    dbus
    webkitgtk_4_1
  ];

  cmakeFlags = [
    "-DSLIC3R_STATIC=0"
    "-DBOOST_ROOT=${boost}"
  ];
})
