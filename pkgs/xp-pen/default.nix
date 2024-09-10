{ lib
, stdenv
, fetchzip
, libusb1
, glibc
, libGL
, xorg
, makeWrapper
, qtx11extras
, wrapQtAppsHook
, autoPatchelfHook
, libX11
, libXtst
, libXi
, libXrandr
, libXinerama
}:

let
  dataDir = "var/lib/xppend1v2";
in
stdenv.mkDerivation rec {
  pname = "xp-pen-driver";
  # version = "4.0.4-240815";
  version = "3.4.9-240607";

  # src = fetchzip {
  #   url = "https://download01.xp-pen.com/file/2024/08/XPPenLinux4.0.4-240815.tar.gz";
  #   name = "XPPenLinux${version}.tar.gz";
  #   hash = "sha256-NVO9VaUmcQDI4rL76BBQDmII8vpmmo9qgcGetv6CIFE=";
  # };

  src = fetchzip {
    url = "https://download01.xp-pen.com/file/2024/06/XPPenLinux3.4.9-240607.tar.gz";
    name = "XPPenLinux${version}.tar.gz";
    hash = "sha256-ZXeTlDjhryXamb7x2LxDdOtf8R9rgKPyUsdx96XchWM=";
  };

  nativeBuildInputs = [
    wrapQtAppsHook
    autoPatchelfHook
    makeWrapper
  ];

  dontBuild = true;

  dontWrapQtApps = true; # this is done manually

  buildInputs = [
    libusb1
    libX11
    libXtst
    libXi
    libXrandr
    libXinerama
    glibc
    libGL
    stdenv.cc.cc.lib
    qtx11extras
  ];

  installPhase = ''
    runHook preInstall

    ls -al .

    mkdir -p $out/{opt,bin}
    cp -r App/usr/lib/pentablet/{PenTablet,resource.rcc,conf} $out/opt
    chmod +x $out/opt/PenTablet
    cp -r App/lib $out/lib
    sed -i 's#usr/lib/pentablet#${dataDir}#g' $out/opt/PenTablet

    runHook postInstall
  '';

  postFixup = ''
    makeWrapper $out/opt/PenTablet $out/bin/XP-Pen \
      "''${qtWrapperArgs[@]}" \
      --run 'if [ "$EUID" -ne 0 ]; then echo "Please run as root."; exit 1; fi' \
      --run 'if [ ! -d /${dataDir} ]; then mkdir -p /${dataDir}; cp -r '$out'/opt/conf /${dataDir}; chmod u+w -R /${dataDir}; fi'
  '';

  meta = with lib; {
    homepage = "https://www.xp-pen.com/product/461.html";
    description = "Drivers for the XP-PEN drawing tablet";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ virchau13 ];
    license = licenses.unfree;
  };
}
