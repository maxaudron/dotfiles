{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  jdk17,
  jre,
  makeWrapper,
}:

let
  # JAXB runtime, required on JDK 11+ (jaxb-api is vendored in external/)
  # glassfish 2.3.x is the last javax-based line and works on recent JDKs
  jaxb = [
    (fetchurl {
      url = "https://repo1.maven.org/maven2/org/glassfish/jaxb/jaxb-runtime/2.3.9/jaxb-runtime-2.3.9.jar";
      hash = "sha256-uojlvefA2HjD4fLsL8q69R0gHq+Ts7uc/s/B8RsjBNQ=";
    })
    (fetchurl {
      url = "https://repo1.maven.org/maven2/org/glassfish/jaxb/txw2/2.3.9/txw2-2.3.9.jar";
      hash = "sha256-lzAYuHr5Eez25thh3Q1qR35Niuaog+xdBz098TMLh/A=";
    })
    (fetchurl {
      url = "https://repo1.maven.org/maven2/com/sun/istack/istack-commons-runtime/4.1.2/istack-commons-runtime-4.1.2.jar";
      hash = "sha256-f9Z5I2H03QD4xWr0ogzswAZt7qSo897Dg0ivI/wilu4=";
    })
    (fetchurl {
      url = "https://repo1.maven.org/maven2/com/sun/activation/jakarta.activation/1.2.2/jakarta.activation-1.2.2.jar";
      hash = "sha256-AhVnc+SunQSNFKVq011kS+6fEFKnkdBy3z3tPGVubho=";
    })
  ];
in
stdenv.mkDerivation (finalAttrs: {
  pname = "gpsmaster";
  version = "0.64.06";

  src = fetchFromGitHub {
    owner = "tboegi";
    repo = "GpsMaster";
    rev = "ad76bd8db1661ebe60d3b9a76a3ed36cbf8352e8";
    hash = "sha256-5bS2o5X4PF4LT4Da8gv/+pWYseFBunUB9ra1bqhN34s=";
  };

  sourceRoot = "source/GpsMaster";

  # allow overriding the hardcoded system look and feel
  patches = [ ./laf-property.patch ];

  nativeBuildInputs = [
    jdk17
    makeWrapper
  ];

  buildPhase = ''
    runHook preBuild

    mkdir classes
    find src -name "*.java" > sources.txt

    javac -nowarn -encoding UTF-8 --release 11 \
      -cp "$(find external -name '*.jar' | tr '\n' ':')" \
      @sources.txt -d classes

    # bundle non-java resources (icons, schemas, images)
    (cd src && find . -type f ! -name '*.java' -print0 | xargs -0 cp -a --parents -t ../classes)
    mkdir -p classes/org/gpsmaster/info
    cp bin/org/gpsmaster/info/*.txt classes/org/gpsmaster/info/

    jar --create --file gpsmaster.jar --main-class org.gpsmaster.GpsMaster -C classes .

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    lib="$out/share/gpsmaster/lib"
    install -D -m 644 gpsmaster.jar "$out/share/gpsmaster/gpsmaster.jar"
    install -D -m 644 external/*.jar -t "$lib"
    install -D -m 644 external/javax/xml/bind/jaxb-api/2.3.0/jaxb-api-2.3.0.jar "$lib"
    install -m 644 ${lib.concatStringsSep " " (map (f: "'${f}'") jaxb)} "$lib"

    mkdir -p "$out/bin"
    makeWrapper "${jre}/bin/java" "$out/bin/gpsmaster" \
      --add-flags "-Dswing.defaultlaf=javax.swing.plaf.metal.MetalLookAndFeel" \
      --add-flags "-cp $out/share/gpsmaster/gpsmaster.jar:$lib/*" \
      --add-flags "org.gpsmaster.GpsMaster"

    mkdir -p "$out/share/applications"
    cat > "$out/share/applications/gpsmaster.desktop" <<EOF
    [Desktop Entry]
    Type=Application
    Name=GpsMaster
    GenericName=GPX editor
    Comment=Analyze, create, edit and view GPX files
    Exec=gpsmaster %F
    Icon=gpsmaster
    Terminal=false
    Categories=Graphics;Geography;
    MimeType=application/gpx+xml;
    EOF

    install -D -m 644 src/org/gpsmaster/icons/gpsmaster.png \
      "$out/share/icons/hicolor/16x16/apps/gpsmaster.png"

    runHook postInstall
  '';

  meta = {
    description = "Desktop application to analyze, create, edit and view GPX files";
    homepage = "https://github.com/tboegi/GpsMaster";
    license = lib.licenses.gpl2Only;
    mainProgram = "gpsmaster";
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})
