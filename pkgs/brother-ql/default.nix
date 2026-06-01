{
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  packbits,
  pillow,
  pyusb,
  click,
  attrs,
  lib,
}:

buildPythonPackage {
  pname = "brother-ql";
  version = "1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "matmair";
    repo = "brother_ql-inventree";
    rev = "5364d30e0ad088fa943642a05863814390d52b4f";
    hash = "sha256-wSekzrpiOeyT51Wlf7haLpPhbY6/PWtZljG88ihrMKo=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    attrs
    click
    packbits
    pillow
    pyusb
  ];

  meta = {
    description = "Python package for the raster language protocol of the Brother QL series label printers";
    longDescription = ''
      Python package for the raster language protocol of the Brother QL series label printers
      (QL-500, QL-550, QL-570, QL-700, QL-710W, QL-720NW, QL-800, QL-820NWB, QL-1050 and more)
    '';
    homepage = "https://github.com/LunarEclipse363/brother_ql_next";
    license = lib.licenses.gpl3Only;
    mainProgram = "brother_ql";
  };
}
