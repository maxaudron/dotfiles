{
  lib,
  appimageTools,
  fetchurl,
}:
let
  pname = "rallynavigator";
  version = "2.6.3";

  src = fetchurl {
    url = "https://downloads.rallynavigator.com/Rally%20Navigator%20Installer.AppImage";
    hash = "sha256-bw8y8hEg3ymk8Qlu0L0wQfsTpP79U0t/AzE1Hu4Lz/Q=";
  };
in
appimageTools.wrapType2 { inherit pname version src; }
