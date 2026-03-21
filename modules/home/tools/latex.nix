{
  config,
  lib,
  pkgs,
  ...
}:

{
    options.my.tools.latex = {
      enable = lib.mkEnableOption "latex";
    };
      
  config = lib.mkIf config.my.tools.latex.enable {
    home.packages = with pkgs; [
      (texlive.combine {
        inherit (pkgs.texlive)
          scheme-small
          latexmk
          beamer
          minted
          wrapfig
          ulem
          capt-of
          fvextra
          fancyvrb
          upquote
          lineno
          catchfile
          xstring
          framed
          float
          datetime2
          tracklang
          xkeyval
          animate
          zref
          media9
          plex
          plex-otf
          fontspec
          moresize
          ocgx2
          pygmentex
          svg
          trimspaces
          transparent
          ;
      })
    ];
  };
}
