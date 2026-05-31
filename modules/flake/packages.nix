{ ... }:

{
  perSystem =
    {
      config,
      self',
      inputs',
      pkgs,
      system,
      ...
    }:
    {
      packages =
        (import ../../pkgs pkgs pkgs)
        // (
          let
            qmk_redox = pkgs.callPackage ../../misc/qmk;
          in
          {
            redox_left = qmk_redox { left = true; };
            redox_right = qmk_redox { left = false; };
          }
        );

      apps = {
        flash_redox_left = (
          import ../../misc/qmk/flash.nix {
            inherit pkgs;
            firmware = self'.packages.redox_left;
          }
        );
        flash_redox_right = (
          import ../../misc/qmk/flash.nix {
            inherit pkgs;
            firmware = self'.packages.redox_right;
          }
        );
      };
    };
}
