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
  boost,
  zlib,
  git,
  # qtscript,
  # phonon,
  libdbusmenu,
  # qca-qt5,
  openldap,

  withKDE ? false, # enable KDE integration

  kdePackages,
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
stdenv.mkDerivation {
  pname = "quassel${tag}";
  version = "0.14.0-20260418";
  src = fetchFromGitHub {
    owner = "johu";
    repo = "quassel";
    rev = "502dad3a00f106997f1b786284d514f8ef89df0a";
    hash = "sha256-nrJizgxnfiFRp1ViBJ8G2uGy4BTb3VqBJLawGTCqRLc=";
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
      kdePackages.qtbase
      boost
      zlib
      git
    ]
    ++ lib.optionals buildCore [
      # qtscript
      # qca-qt5
      openldap
    ]
    ++ lib.optionals buildClient [
      libdbusmenu
      kdePackages.phonon
      kdePackages.qt5compat
      kdePackages.sonnet
      kdePackages.mlt
      kdePackages.breeze-icons
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
      wrapProgram "$out/bin/quasselcore" --suffix PATH : "${kdePackages.qtbase}/bin"
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
    inherit (kdePackages.qtbase.meta) platforms;
  };
}
