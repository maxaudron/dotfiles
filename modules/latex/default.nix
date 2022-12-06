{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    (texlive.combine {
      inherit (pkgs.texlive)
        scheme-basic latexmk xetex beamer minted wrapfig ulem capt-of fvextra
        fancyvrb upquote lineno catchfile xstring framed float datetime2
        tracklang xkeyval animate zref media9 plex plex-otf fontspec moresize;
    })

    python
    pythonPackages.pygments
  ];
}
