{ lib, ... }:

with lib;
{
  imports = [
    ./emacs
    ./vim
    ./zed
  ];

  config.my.editor.vim.enable = mkDefault true;
}
