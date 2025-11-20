{
  lib,
  stdenv,
  fetchurl,
  fetchzip,
  makeWrapper,
  makeDesktopItem,
  zlib,
  glib,
  libpng,
  freetype,
  openssl,
  xorg,
  fontconfig,
  qtbase,
  qtdeclarative,
  # qtwebengine,
  qtwebchannel,
  qtsvg,
  qtwebsockets,
  xkeyboard_config,
  alsa-lib,
  libpulseaudio ? null,
  libredirect,
  quazip,
  which,
  perl,
  llvmPackages,

  libGL,
  nss,
  nspr,
  libevent,
  expat,
  libxkbcommon,
  dbus,
  pciutils,
  libxml2_13,
  libxslt,
  lcms,
}:

let

  arch = "amd64";

  libDir = "lib64";

  deps = [
    zlib
    glib
    libpng
    freetype
    xorg.libSM
    xorg.libICE
    xorg.libXrender
    openssl
    xorg.libXrandr
    xorg.libXfixes
    xorg.libXcursor
    xorg.libXinerama
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXtst
    xorg.libxcb
    fontconfig
    xorg.libXext
    xorg.libX11
    alsa-lib
    qtbase
    qtdeclarative
    # qtwebengine
    qtwebchannel
    qtsvg
    qtwebsockets
    libpulseaudio
    quazip
    llvmPackages.libcxx

    libGL
    nss
    nspr
    libevent
    expat
    libxkbcommon
    dbus
    pciutils
    libxml2_13
    libxslt
    lcms
  ];

  desktopItem = makeDesktopItem {
    name = "teamspeak";
    exec = "ts3client";
    icon = "teamspeak";
    comment = "The TeamSpeak voice communication tool";
    desktopName = "TeamSpeak";
    genericName = "TeamSpeak";
    categories = [ "Network" ];
  };
in

stdenv.mkDerivation rec {
  pname = "teamspeak-client";

  version = "3.6.2";

  src = fetchurl {
    url = "https://files.teamspeak-services.com/releases/client/${version}/TeamSpeak3-Client-linux_${arch}-${version}.run";
    hash = "sha256-WfEQQ4lxoj+QSnAOfdCoEc+Z1Oa5dbo6pFli1DsAZCI=";
  };

  # grab the plugin sdk for the desktop icon
  pluginsdk = fetchzip {
    url = "https://files.teamspeak-services.com/releases/sdk/3.3.1/ts_sdk_3.3.1.zip";
    hash = "sha256-wx4pBZHpFPoNvEe4xYE80KnXGVda9XcX35ho4R8QxrQ=";
  };

  nativeBuildInputs = [
    makeWrapper
    which
    perl # Installer script needs `shasum`
  ];

  # This just runs the installer script. If it gets stuck at something like
  # ++ exec
  # + PAGER_PATH=
  # it's looking for a dependency and didn't find it. Check the script and make sure the dep is in nativeBuildInputs.
  unpackPhase = ''
    echo -e '\ny' | PAGER=cat sh -xe $src
    cd TeamSpeak*
  '';

  buildPhase = let rpath = "${lib.makeLibraryPath deps}:$(cat $NIX_CC/nix-support/orig-cc)/${libDir}:$ORIGIN"; in ''
    mv ts3client_linux_${arch} ts3client
    echo "patching ts3client..."

    patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath '${rpath}' \
      --force-rpath \
      QtWebEngineProcess
    
    patchelf \
      --set-rpath '${rpath}' \
      --force-rpath \
      libQt5WebEngineCore.so.5
    
    patchelf \
      --set-rpath '${rpath}' \
      --force-rpath \
      libQt5WebEngineWidgets.so.5

    patchelf --replace-needed libquazip.so ${quazip}/lib/libquazip1-qt5.so ts3client
    patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath '${rpath}' \
      --force-rpath \
      ts3client
  '';

  installPhase =
    ''
      # Delete unecessary libraries - these are provided by nixos.
      # rm *.so.* *.so
      # rm QtWebEngineProcess
      rm qt.conf
      rm -r platforms # contains libqxcb.so

      rm libc++.so.1
      rm libc++abi.so.1
      rm libcrypto.so.1.1
      rm libGL.so
      rm libQt5Core.so.5
      rm libQt5DBus.so.5
      rm libQt5Gui.so.5
      rm libQt5Network.so.5
      rm libQt5PrintSupport.so.5
      rm libQt5Qml.so.5
      rm libQt5QmlModels.so.5
      rm libQt5Quick.so.5
      rm libQt5QuickWidgets.so.5
      rm libQt5Sql.so.5
      rm libQt5Svg.so.5
      rm libQt5WebChannel.so.5
      # rm libQt5WebEngineCore.so.5
      # rm libQt5WebEngineWidgets.so.5
      rm libQt5WebSockets.so.5
      rm libQt5Widgets.so.5
      rm libQt5XcbQpa.so.5
      rm libquazip.so
      rm libssl.so.1.1
      rm libunwind.so.1

      # Install files.
      mkdir -p $out/lib/teamspeak
      mv * $out/lib/teamspeak/

      # Make a desktop item
      mkdir -p $out/share/applications/ $out/share/icons/hicolor/64x64/apps/
      cp ${pluginsdk}/doc/_static/logo.png $out/share/icons/hicolor/64x64/apps/teamspeak.png
      cp ${desktopItem}/share/applications/* $out/share/applications/

      # Make a symlink to the binary from bin.
      mkdir -p $out/bin/
      ln -s $out/lib/teamspeak/ts3client $out/bin/ts3client

      wrapProgram $out/bin/ts3client \
        --set LD_PRELOAD "${libredirect}/lib/libredirect.so" \
        --set QT_PLUGIN_PATH "${qtbase}/${qtbase.qtPluginPrefix}" \
    '' # wayland is currently broken, remove when TS3 fixes that
    + ''
      --set QT_QPA_PLATFORM xcb \
      --set NIX_REDIRECTS /usr/share/X11/xkb=${xkeyboard_config}/share/X11/xkb
    '';

  dontStrip = true;
  dontPatchELF = true;

  meta = with lib; {
    description = "TeamSpeak voice communication tool";
    homepage = "https://teamspeak.com/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = {
      # See distribution-permit.txt for a confirmation that nixpkgs is allowed to distribute TeamSpeak.
      fullName = "Teamspeak client license";
      url = "https://www.teamspeak.com/en/privacy-and-terms/";
      free = false;
    };
    maintainers = with maintainers; [
      lhvwb
      lukegb
      atemu
    ];
    mainProgram = "ts3client";
    platforms = [ "x86_64-linux" ];
  };
}
