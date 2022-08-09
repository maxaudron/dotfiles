{ lib, stdenv, fetchurl, qt5, obs-studio, alsa-lib }:

stdenv.mkDerivation {
  pname = "obs-midi";
  version = "0.9.3";

  src = fetchurl {
    url =
      "https://github.com/cpyarger/obs-midi/releases/download/tag-0.9.3-ALPHA-3.66/obs-midi-Linux-0.9.3-ALPHA-3.66-x64.tar.gz";
    sha256 = "17lb9w51jkknrcb8jdjnfzgz24l5nifbn7hclwvwifdb8mhbahr0";
  };

  installPhase = ''
    mkdir -p $out/lib/obs-plugins/
    cp -r plugins/obs-midi/bin/64bit/obs-midi.so $out/lib/obs-plugins/
  '';

  preFixup = let
    libPath =
      lib.makeLibraryPath [ stdenv.cc.cc.lib obs-studio qt5.qtbase alsa-lib ];
  in ''
    patchelf \
      --set-rpath "${libPath}" \
      $out/lib/obs-plugins/obs-midi.so
  '';

  meta = with lib; {
    description =
      "An obs-studio plugin that allows you to screen capture on wlroots based wayland compositors";
    homepage = "https://hg.sr.ht/~scoopta/wlrobs";
    maintainers = with maintainers; [ grahamc V ];
    license = licenses.gpl3Plus;
    platforms = [ "x86_64-linux" ];
  };
}
