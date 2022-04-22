{ stdenv, lib, fetchFromGitHub, kubectl, makeWrapper }:

with lib;

stdenv.mkDerivation {
  name = "grub2-theme";
  src = (fetchFromGitHub {
    owner = "vinceliuice";
    repo = "grub2-themes";
    rev = "master";
    hash = "sha256:1qr9r72zviby3h37z7y8bsc3s9qizsn4fzy7gkh7szzdnxczcbaf";
  });

  installPhase = ''
    mkdir -p $out/grub/themes;
    bash ./install.sh \
      --generate $out/grub/themes \
      --screen ultrawide2k \
      --theme vimix \
      --icon white;

    cp ${../../wallpaper/blade_runner/mpv-shot0003.jpg} $out/grub/themes/vimix/background.jpg;
  '';
}
