{ ... }:
rec {
  common = import ./common.nix;
  aerospace = import ./aerospace;

  default =
    { ... }:
    {
      imports = [
        common
      ];
    };
}
