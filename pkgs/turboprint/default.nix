{
  lib,
  stdenv,
  fetchurl,

  autoPatchelfHook,
  makeWrapper,

  rpm,
  cpio,

  cups,
  libsForQt5,
  gtk2,
  at-spi2-atk,
  gimp2,
  xdg-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "turboprint";
  version = "3.01-1";

  src = fetchurl {
    url = "https://www.zedonet.com/download/tp3/turboprint-${finalAttrs.version}.x86_64.rpm";
    hash = "sha256-usvBHy1co5uLinzDiC2TSWokPGq1qRibgRGJ11YISj0=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    libsForQt5.wrapQtAppsHook
    makeWrapper

    rpm
    cpio
  ];

  buildInputs = with libsForQt5.qt5; [
    cups

    qtbase
    gtk2
    at-spi2-atk
    gimp2
  ];

  unpackPhase = ''
    runHook preUnpack
    rpm2cpio $src | cpio -idm --make-directories
    runHook postUnpack
  '';

  qtWrapperArgs = [
    "--prefix PATH : ${cups}/bin:${placeholder "out"}/bin"
    "--set LD_PRELOAD ${placeholder "out"}/lib/pathshim.so"
  ];

  buildPhase = ''
    gcc -shared -fPIC -O2 ${./pathshim.c} -o pathshim.so -ldl
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r etc/ $out/
    cp -r usr/bin/ usr/share/ usr/lib/ $out/

    mkdir -p $out/lib
    cp pathshim.so $out/lib/

    rm $out/lib/turboprint/gnomeapplet/tpgnomeapplet
    rm -rf $out/lib/.build-id/

    cat << EOF > $out/etc/turboprint/system.cfg
    TPBIN_BROWSER=${xdg-utils}/bin/xdg-open
    TPFILE_PRINTCAP=/etc/printcap
    TPPATH_CONFIG=/var/lib/turboprint
    TPPATH_SHARE=$out/share/turboprint
    TPPATH_SPOOL=/var/spool/lpd
    TPPATH_BIN=/usr/bin
    TPPATH_FILTERS=$out/lib/turboprint
    TPPATH_DOC=$out/share/doc/turboprint
    TPPATH_LOG=/var/log
    TPPATH_VAR=/var/spool
    TPPATH_TEMP=/tmp
    TPPATH_MAN=$out/share/man
    TPPATH_CUPSDRIVER=${cups}/share/cups/model
    TPPATH_CUPSSETTINGS=/etc/cups/ppd
    TPPATH_CUPSLIB=${cups}/lib/cups
    TPPATH_CUPSLIB64=${cups}/lib/cups
    TPOWN_SPOOLDIR=lp
    TPMOD_SPOOLDIR=0755
    TPOWN_SPOOLFILE=lp
    TPMOD_SPOOLFILE=0640
    TPDAEMON_START=1
    TPDAEMON_USER=lp
    TPDAEMON_GROUP=lp
    TPDAEMON_PORT=5552
    TPDAEMON_SERVER=1
    TPUSE_GSZEDO=1
    TPCONVERT_PDF=0
    EOF

    runHook postInstall
  '';
})
