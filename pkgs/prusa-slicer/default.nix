{
  stdenv,
  fetchFromGitHub,

  cmake,
  pkg-config,
  autoconf,
  makeDesktopItem,
  wrapGAppsHook3,
  boost186,
  gmp,
  mpfr,

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
  cgal_5,
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
  yaml-cpp,
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

let
  # CGAL 5.6.x needs boost <= 1.87: CGAL uses boost::mpl without including
  # its headers, and the transitive includes disappeared in boost 1.88 (mpl
  # itself was removed in 1.89). PrusaSlicer 3.0 alpha pins boost 1.86 in its
  # CI deps. gmp/mpfr headers are included by CGAL's gmpxx.h, so propagate.
  cgal = (cgal_5.override { boost = boost186; }).overrideAttrs (_: {
    propagatedBuildInputs = [
      boost186
      gmp
      mpfr
    ];
  });

  # PrusaSlicer uses the fltk fork of nanosvg: it adds nsvgRasterizeXY(),
  # which upstream memononen/nanosvg does not provide.
  nanosvg-fltk = nanosvg.overrideAttrs (old: {
    pname = "nanosvg-fltk";
    version = "unstable-2022-12-22";
    src = fetchFromGitHub {
      owner = "fltk";
      repo = "nanosvg";
      rev = "abcd277ea45e9098bed752cf9c6875b533c0892f";
      hash = "sha256-WNdAYu66ggpSYJ8Kt57yEA4mSTv+Rvzj9Rm1q765HpY=";
    };
  });

  # nlohmann/json v3.12.0 tag has a broken #guard for its std::optional
  # from_json overloads (patch vendored from prusa's deps/+json/json.patch).
  # Those overloads are only active with implicit conversions disabled, as in
  # prusa's deps/+json/json.cmake.
  json = nlohmann_json.overrideAttrs (old: {
    patches = old.patches ++ [ ./nlohmann_json-optional.patch ];
    cmakeFlags = old.cmakeFlags ++ [ "-DJSON_ImplicitConversions=OFF" ];
    doCheck = false;
  });

  # wxWidgets 3.3.3.1 added `wxColour(bool) = delete;`; as a deleted (but
  # declared) constructor it participates in overload resolution and makes
  # prusa's single-element StateHandler::attach({&color}) calls ambiguous.
  wxwidgets = wxwidgets_3_3.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      substituteInPlace include/wx/colour.h \
        --replace-fail 'wxColour(bool) = delete;' '// wxColour(bool) = delete;  # neutralized for prusa-slicer-3 overload ambiguity'
    '';
  });

  # upstream's com.prusa3d.PrusaSlicer.desktop.in hardcodes the flatpak Exec
  desktopItem = makeDesktopItem {
    name = "com.prusa3d.PrusaSlicer";
    desktopName = "PrusaSlicer 3";
    genericName = "3D Printing Software";
    icon = "com.prusa3d.PrusaSlicer";
    exec = "prusa-slicer3 --single-instance-on-url %u";
    terminal = false;
    type = "Application";
    mimeTypes = [
      "model/stl"
      "application/vnd.ms-3mfdocument"
      "application/prs.wavefront-obj"
      "application/x-amf"
      "x-scheme-handler/prusaslicer"
    ];
    categories = [
      "Graphics"
      "3DGraphics"
      "Engineering"
    ];
    keywords = [
      "3D"
      "Printing"
      "Slicer"
      "slice"
      "printer"
      "convert"
      "gcode"
      "stl"
      "obj"
      "amf"
      "SLA"
    ];
    startupNotify = false;
    startupWMClass = "prusa-slicer3";
  };
in

stdenv.mkDerivation (finalAttrs: {
  pname = "prusa-slicer-3";
  version = "3.0.0-alpha12";
  src = fetchFromGitHub {
    owner = "prusa3d";
    repo = "PrusaSlicer";
    hash = "sha256-T40R+K9h2o5QyAiLPQAnL/yx3HLzHWtgh0e8t3D1DHY=";
    rev = "version_${finalAttrs.version}";
  };

  patches = [
    ./boost_no_system.patch
    # upstream bug: recursive fs::copy preserves the read-only (0555)
    # permissions of store resources, making the copied preset tree in
    # ~/.config/PrusaSlicer3-dev unwritable
    ./bundle-loader-store-perms.patch
  ];

  postPatch = ''
    substituteInPlace src/slic3r-platform-wx/CMakeLists.txt \
      --replace-fail 'find_package(wxWidgets 3.3 CONFIG' 'find_package(wxWidgets 3.3 MODULE'

    # ship resources in share/PrusaSlicer3 instead of share/PrusaSlicer, so
    # the profile does not collide with prusa-slicer 2.x; this also updates
    # the SLIC3R_FHS_RESOURCES macro baked into the binary
    sed -i 's|DATAROOTDIR}/PrusaSlicer"|DATAROOTDIR}/PrusaSlicer3"|' \
      src/slic3r-shared/CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    autoconf
    # installs GSettings schemas / icon themes / loaders env into the binaries
    # (without it, GTK aborts with "Settings schema 'org.gtk.Settings.FileChooser' is not installed")
    wrapGAppsHook3
  ];

  buildInputs = [
    boost186

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
    nanosvg-fltk
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
    json
    yaml-cpp
    pugixml
    rapidyaml
    magic-enum
    range-v3
    libdeflate
    curl
    wxwidgets

    libGLU
    gtk3
    dbus
    webkitgtk_4_1
  ];

  cmakeFlags = [
    "-DSLIC3R_STATIC=0"
    "-DSLIC3R_BUILD_TESTS=0"
    # compile resources into $out/share/PrusaSlicer instead of resolving
    # "bin/../resources" at runtime, which the gapps wrapper would break
    "-DSLIC3R_FHS=ON"
    "-DBOOST_ROOT=${boost186}"
  ];

  # runs before wrapGAppsHook3's fixup hook, so the wrapper is generated
  # around the renamed prusa-slicer3 binary
  postInstall = ''
    mv $out/bin/slic3r-app-launcher $out/bin/prusa-slicer3

    install -Dm644 ${desktopItem}/share/applications/com.prusa3d.PrusaSlicer.desktop \
      $out/share/applications/com.prusa3d.PrusaSlicer.desktop

    install -Dm644 ../resources/icons/PrusaSlicer.svg \
      $out/share/icons/hicolor/scalable/apps/com.prusa3d.PrusaSlicer.svg
    install -Dm644 ../resources/icons/PrusaSlicer_128px.png \
      $out/share/icons/hicolor/128x128/apps/com.prusa3d.PrusaSlicer.png
  '';

  # wrapGAppsHook3 also "wraps" OCCTWrapper.so into an executable stub, which
  # would break dlopen() of the exe-dir-relative library. Undo that: the real
  # library stays in bin/ under its own name (2.x keeps its copy in lib/, so
  # the profile sees no collision).
  postFixup = ''
    if [ -f $out/bin/.OCCTWrapper.so-wrapped ]; then
      mv -f $out/bin/.OCCTWrapper.so-wrapped $out/bin/OCCTWrapper.so
    fi
  '';
})
