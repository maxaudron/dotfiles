{ lib, ... }:
{
  imports = [
    ./git
    ./gpg
    ./ssh

    ./shell
    ./terminal
  ];

  my.core.gpg.enable = lib.mkDefault true;
}
