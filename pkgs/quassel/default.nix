{
  monolithic ? false, # build monolithic Quassel
  enableDaemon ? false, # build Quassel daemon
  client ? true, # build Quassel client
  tag ? "-kf6", # tag added to the package name
  static ? false, # link statically

  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  makeWrapper,
  wrapQtAppsHook,
  dconf,
  qtbase,
  boost,
  zlib,
  # qtscript,
  # phonon,
  libdbusmenu,
  # qca-qt5,
  openldap,

  withKDE ? false, # enable KDE integration
  extra-cmake-modules,

  kdePackages,
  # kconfigwidgets,
  # kcoreaddons,
  # knotifications,
  # knotifyconfig,
  # ktextwidgets,
  # kwidgetsaddons,
  # kxmlgui,
}:

let
  buildClient = monolithic || client;
  buildCore = monolithic || enableDaemon;
in

assert monolithic -> !client && !enableDaemon;
assert client || enableDaemon -> !monolithic;
assert !buildClient -> !withKDE; # KDE is used by the client only

let
  edf = flag: feature: [ ("-D" + feature + (if flag then "=ON" else "=OFF")) ];

in
stdenv.mkDerivation rec {
  pname = "quassel${tag}";
  version = "0.14.0-20250727";
  src = fetchFromGitHub {
    owner = "FuzzyGophers";
    repo = "quassel";
    rev = "28bc5e37a6e7e1a071f22476d7fdf7f9273c6f87";
    hash = "sha256-Cjnwmxzj9HHDlL9/jNNM+1NZkAln2qRe2BTia3ssZHM=";
    fetchSubmodules = true;
  };

  # Prevent ``undefined reference to `qt_version_tag''' in SSL check
  env.NIX_CFLAGS_COMPILE = "-DQT_NO_VERSION_TAGGING=1";

  nativeBuildInputs = [
    cmake
    makeWrapper
    wrapQtAppsHook
  ];
  buildInputs =
    [
      qtbase
      boost
      zlib
    ]
    ++ lib.optionals buildCore [
      # qtscript
      # qca-qt5
      openldap
    ]
    ++ lib.optionals buildClient [
      libdbusmenu
      kdePackages.phonon
    ]
    ++ lib.optionals (buildClient && withKDE) [
      kdePackages.extra-cmake-modules
      kdePackages.kconfigwidgets
      kdePackages.kcoreaddons
      kdePackages.knotifications
      kdePackages.knotifyconfig
      kdePackages.ktextwidgets
      kdePackages.kwidgetsaddons
      kdePackages.kxmlgui
    ];


  cmakeFlags =
    [
      "-DEMBED_DATA=OFF"
      "-DUSE_QT5=ON"
      "-DCMAKE_INSTALL_DATAROOTDIR=usr/share"
      "-DENABLE_SHARED=OFF"
    ]
    ++ edf static "STATIC"
    ++ edf monolithic "WANT_MONO"
    ++ edf enableDaemon "WANT_CORE"
    ++ edf enableDaemon "WITH_LDAP"
    ++ edf client "WANT_QTCLIENT"
    ++ edf withKDE "WITH_KDE";

  dontWrapQtApps = true;

  postFixup =
    lib.optionalString enableDaemon ''
      wrapProgram "$out/bin/quasselcore" --suffix PATH : "${qtbase}/bin"
    ''
    + lib.optionalString buildClient ''
      wrapQtApp "$out/bin/quassel${lib.optionalString client "client"}" \
        --prefix GIO_EXTRA_MODULES : "${dconf}/lib/gio/modules"
    '';

  meta = with lib; {
    homepage = "https://quassel-irc.org/";
    description = "Qt/KDE distributed IRC client supporting a remote daemon";
    longDescription = ''
      Quassel IRC is a cross-platform, distributed IRC client,
      meaning that one (or multiple) client(s) can attach to
      and detach from a central core -- much like the popular
      combination of screen and a text-based IRC client such
      as WeeChat, but graphical (based on Qt4/KDE4 or Qt5/KF5).
    '';
    license = licenses.gpl3;
    maintainers = with maintainers; [ ttuegel ];
    mainProgram =
      if monolithic then
        "quassel"
      else if buildClient then
        "quasselclient"
      else
        "quasselcore";
    inherit (qtbase.meta) platforms;
  };
}
