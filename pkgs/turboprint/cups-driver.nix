{
  lib,
  runCommand,
  bash,
  glibc,
  coreutils,
  procps,
  gnugrep,
  turboprint,
}:

let
  # The filter PATH given by cupsd only contains cups-progs (ServerBin);
  # the vendor filter scripts use these core utilities, and
  # turboprint-cupsfilter spawns its RIP child via "sh -c".
  tools = lib.makeBinPath [
    bash
    coreutils
    procps
    gnugrep
    glibc.bin
  ];
in
runCommand "turboprint-cups-driver-${turboprint.version}" { } ''
  mkdir -p $out/lib/cups/filter $out/lib/cups/backend

  # The vendor filter scripts have "#! /bin/bash" shebangs (which don't
  # exist on NixOS) and assume FHS PATHs; prepend the needed tools
  # instead. "pfstdin" refers to tpstdin, which was renamed upstream.

  install -m 755 ${turboprint}/lib/turboprint/anytoturboprint $out/lib/cups/filter/anytoturboprint
  sed -i \
    -e '1s|.*|#!${bash}/bin/bash|' \
    -e '1a PATH=${tools}:$PATH' \
    -e 's|pfstdin|tpstdin|' \
    $out/lib/cups/filter/anytoturboprint

  install -m 755 ${turboprint}/lib/turboprint/pstoturboprint $out/lib/cups/filter/pstoturboprint
  sed -i \
    -e '1s|.*|#!${bash}/bin/bash|' \
    -e '1a PATH=${tools}:$PATH' \
    -e 's|^PATH=\(/bin:/usr/bin.*\)$|PATH=$PATH:\1|' \
    $out/lib/cups/filter/pstoturboprint

  install -m 755 ${turboprint}/lib/turboprint/commandtoturboprint $out/lib/cups/filter/commandtoturboprint
  sed -i \
    -e '1s|.*|#!${bash}/bin/bash|' \
    -e '1a PATH=${tools}:$PATH' \
    -e 's|^PATH=\(/usr/lib/cups/filter.*\)$|PATH=$PATH:\1|' \
    -e 's|^source pstoturboprint$|source "$(dirname "$0")/pstoturboprint"|' \
    $out/lib/cups/filter/commandtoturboprint

  # CUPS backend for TurboPrint-supported USB printers
  ln -s ${turboprint}/lib/turboprint/tpu $out/lib/cups/backend/tpu
''
