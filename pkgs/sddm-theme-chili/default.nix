{ lib, stdenv, fetchFromGitHub, libsForQt5 }:

stdenv.mkDerivation rec {
  pname = "sddm-theme-chili";
  version = "2018-08-27";

  src = fetchFromGitHub {
    owner = "MarianArlt";
    repo = "sddm-chili";
    rev = "6516d50";
    sha256 = "sha256-wxWsdRGC59YzDcSopDRzxg8TfjjmA3LHrdWjepTuzgw=";
  };

  buildInputs = [
    libsForQt5.qt5.qtquickcontrols
    libsForQt5.qt5.qtgraphicaleffects
    libsForQt5.qt5.qtwayland
  ];
  propagatedUserEnvPkgs = [ libsForQt5.qt5.qtgraphicaleffects ];

  dontWrapQtApps = true;

  installPhase = ''
    mkdir -p $out/share/sddm/themes/chili
    cp -r ./ $out/share/sddm/themes/chili/
    cp -r ${../../wallpaper/blade_runner/mpv-shot0001.jpg} $out/share/sddm/themes/chili/assets/background.jpg
    cp -r ${./theme.conf} $out/share/sddm/themes/chili/theme.conf
  '';
}
