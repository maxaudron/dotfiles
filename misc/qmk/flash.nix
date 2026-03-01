{
  pkgs,
  firmware,
}:
let
  flash = pkgs.writeShellApplication {
    name = "qmk_flash";
    text = ''
      mount /mnt/rp2040
      cp ${firmware}/*.uf2 /mnt/rp2040/
      sync
    '';
  };
in
{
  type = "app";
  program = "${flash}/bin/qmk_flash";
}
