{
  config,
  lib,
  pkgs,
  ...
}:

let
  conf = import ../config { inherit lib; };
in
{
}
