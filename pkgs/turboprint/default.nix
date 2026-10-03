{
  lib,
  stdenv,
  fetchurl,

  autoPatchelfHook,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,

  rpm,
  cpio,

  cups,
  libsForQt5,
  gtk2,
  at-spi2-atk,
  gimp2,
  xdg-utils,
  libusb1,
}:

let
  # @out@ is replaced by the package's own out path in postFixup,
  # so the entries don't rely on the binaries being on $PATH
  desktopItems = [
    (makeDesktopItem {
      name = "turboprint-control";
      desktopName = "TurboPrint Control";
      comment = "Setup & configure TurboPrint printers";
      exec = "@out@/bin/turboprint";
      icon = "turboprint-icon";
      categories = [
        "System"
        "Settings"
      ];
      startupNotify = true;
      terminal = false;
      extraConfig = {
        DocPath = "@out@/share/doc/turboprint/TurboPrint_Manual.pdf";
      };
    })
    (makeDesktopItem {
      name = "turboprint-composer";
      desktopName = "TurboPrint Composer";
      comment = "Print images and documents with TurboPrint printer";
      exec = "@out@/bin/turboprint-composer %F";
      icon = "turboprint-composer";
      mimeTypes = [
        "image/jpeg"
        "image/png"
        "image/tiff"
        "application/postscript"
        "application/pdf"
      ];
      categories = [
        "Graphics"
        "Photography"
        "Printing"
      ];
      startupNotify = true;
      terminal = false;
      extraConfig = {
        DocPath = "@out@/share/doc/turboprint/TurboPrint_Manual.pdf";
      };
    })
    (makeDesktopItem {
      name = "turboprint-monitor";
      desktopName = "TurboPrint Monitor";
      comment = "Monitor TurboPrint printers";
      exec = "@out@/bin/turboprint-monitor";
      icon = "turboprint-monitor";
      categories = [
        "System"
        "Settings"
      ];
      startupNotify = false;
      terminal = false;
      extraConfig = {
        DocPath = "@out@/share/doc/turboprint/TurboPrint_Manual.pdf";
      };
    })
  ];
in
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
    copyDesktopItems

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

  inherit desktopItems;

  unpackPhase = ''
    runHook preUnpack
    rpm2cpio $src | cpio -idm --make-directories
    runHook postUnpack
  '';

  qtWrapperArgs = [
    "--prefix PATH : ${cups}/bin:${placeholder "out"}/bin"
    "--set LD_PRELOAD ${placeholder "out"}/lib/pathshim.so"
    # tpu and tprintdaemon dlopen libusb, invisible to autoPatchelfHook;
    # autoPatchelf rewrites RUNPATHs of wrapped binaries, so inject it here
    "--prefix LD_LIBRARY_PATH : ${libusb1}/lib"
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

    # desktop entries are copied by the copyDesktopItems hook

    mkdir -p $out/share/mime/packages

    # hicolor icons, installed at runtime via xdg-icon-resource by lib/install-post

    install -Dm644 $out/share/turboprint/img/turboprint-icon.png $out/share/icons/hicolor/48x48/apps/turboprint-icon.png
    install -Dm644 $out/share/turboprint/img/turboprint-monitor.png $out/share/icons/hicolor/48x48/apps/turboprint-monitor.png
    install -Dm644 $out/share/turboprint/img/turboprint-composer.png $out/share/icons/hicolor/48x48/apps/turboprint-composer.png
    install -Dm644 $out/share/turboprint/img/turboprint-icon-128.png $out/share/icons/hicolor/128x128/apps/turboprint-icon.png
    install -Dm644 $out/share/turboprint/img/turboprint-monitor-128.png $out/share/icons/hicolor/128x128/apps/turboprint-monitor.png
    install -Dm644 $out/share/turboprint/img/turboprint-composer-128.png $out/share/icons/hicolor/128x128/apps/turboprint-composer.png
    install -Dm644 $out/share/turboprint/img/turboprint-key.png $out/share/icons/hicolor/48x48/mimetypes/application-turboprint-key.png
    install -Dm644 $out/share/turboprint/img/turboprint-profile.png $out/share/icons/hicolor/48x48/mimetypes/application-turboprint-profile.png
    install -Dm644 $out/share/turboprint/img/turboprint-key-128.png $out/share/icons/hicolor/128x128/mimetypes/application-turboprint-key.png
    install -Dm644 $out/share/turboprint/img/turboprint-profile-128.png $out/share/icons/hicolor/128x128/mimetypes/application-turboprint-profile.png

    # TurboPrint mime types (.tpkey/.tp2key and .pfprofile files)

    install -m644 $out/share/turboprint/img/turboprint-tpkey.xml $out/share/mime/packages/
    install -m644 $out/share/turboprint/img/turboprint-profile.xml $out/share/mime/packages/

    runHook postInstall
  '';

  postFixup = ''
    substituteInPlace $out/share/applications/*.desktop --replace-fail "@out@" "$out"

    patchelf --add-rpath ${libusb1}/lib $out/lib/turboprint/tpu
  '';
})
