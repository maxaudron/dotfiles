" ======================================================================
" Laravel
" ======================================================================
" A Sublime Text 2 / Textmate theme.
" Copyright (c) 2014 Dayle Rees.
" Released under the MIT License <http://opensource.org/licenses/MIT>
" ======================================================================
" Find more themes at : https://github.com/daylerees/colour-schemes
" ======================================================================

set background=dark
hi clear
syntax reset

" Colors for the User Interface.

hi Cursor      guibg=#cc4455  guifg=white     ctermbg=4 ctermfg=15
hi link CursorIM Cursor
hi Normal      guibg=#181818  guifg=#DEDEDE    gui=none ctermbg=0 ctermfg=15
hi NonText     guibg=bg  guifg=#DEDEDE   ctermbg=8 ctermfg=14
hi Visual      guibg=#333333  guifg=white    gui=none ctermbg=9 ctermfg=15

hi Linenr      guibg=bg       guifg=#626262  gui=none ctermbg=bg ctermfg=7

hi CursorLine  guibg=#333333       guifg=none  gui=none ctermbg=bg ctermfg=7
hi CursorLineNr  guibg=#333333       guifg=#f5f5f5  gui=none ctermbg=bg ctermfg=7

hi MatchParen ctermfg=black ctermbg=lightgreen guifg=#E88A30 guibg=#333333

hi Directory   guibg=bg       guifg=#337700  gui=none ctermbg=bg ctermfg=10

hi IncSearch   guibg=#71a3e5  guifg=white    gui=none ctermbg=1 ctermfg=15
hi link Seach IncSearch

hi SpecialKey  guibg=bg guifg=fg       gui=none ctermbg=bg ctermfg=fg
hi Titled      guibg=bg guifg=fg       gui=none ctermbg=bg ctermfg=fg

hi ErrorMsg    guibg=bg guifg=#ff0000   ctermbg=bg ctermfg=12
hi ModeMsg     guibg=bg guifg=#ffeecc  gui=none ctermbg=bg ctermfg=14
hi link  MoreMsg     ModeMsg
hi Question    guibg=bg guifg=#FFC48C   ctermbg=bg ctermfg=10
hi link  WarningMsg  ErrorMsg

hi StatusLine     guibg=#181818  guifg=#f5f5f5     ctermbg=0 ctermfg=7
hi StatusLineNC   guibg=#cc4455  guifg=white    gui=none ctermbg=4  ctermfg=11
hi VertSplit      guibg=#242424  guifg=white    gui=none ctermbg=4  ctermfg=11

hi Pmenu ctermfg=2 ctermbg=3 guifg=#f5f5f5 guibg=#181818

hi TabLineSel     guibg=#181818  guifg=white     ctermbg=none ctermfg=none
hi TabLineFill    guibg=#181818  guifg=white     ctermbg=none ctermfg=none

hi DiffAdd     guifg=#5fba5e  guibg=#181818    gui=none ctermbg=1 ctermfg=fg
hi DiffChange  guifg=#71a3e5  guibg=#181818    gui=none ctermbg=2 ctermfg=fg
hi DiffDelete  guifg=#DB4B3F  guibg=#181818    gui=none ctermbg=4 ctermfg=fg
hi DiffText    guifg=#EB9A4C  guibg=#181818     ctermbg=4 ctermfg=fg

hi link GitGutterAdd DiffAdd 
hi link GitGutterChange DiffChange
hi link GitGutterDelete DiffDelete
hi link GitGutterChangeDelete DiffText
" Colors for Syntax Highlighting.

hi Comment  guibg=bg  guifg=#615953  gui=none    ctermbg=8   ctermfg=7

hi Constant    guibg=bg    guifg=white        ctermbg=8   ctermfg=15
hi String      guibg=bg    guifg=#E88A30    ctermbg=bg  ctermfg=14
hi Character   guibg=bg    guifg=#DB4B3F      ctermbg=bg  ctermfg=14
hi Number      guibg=bg    guifg=#f77c55      ctermbg=1   ctermfg=15
hi Boolean     guibg=bg    guifg=#f77c55  gui=none    ctermbg=1   ctermfg=15
hi Float       guibg=bg    guifg=#f77c55      ctermbg=1   ctermfg=15

hi Identifier  guibg=bg    guifg=#DEDEDE      ctermbg=bg  ctermfg=12
hi Function    guibg=bg    guifg=#DB4B3F      ctermbg=bg  ctermfg=12
hi Statement   guibg=bg    guifg=#DB4B3F      ctermbg=bg  ctermfg=14

hi Conditional guibg=bg    guifg=#FFA927      ctermbg=bg  ctermfg=12
hi Repeat      guibg=bg    guifg=#FFA927      ctermbg=4   ctermfg=14
hi Label       guibg=bg    guifg=#ffccff      ctermbg=bg   ctermfg=13
hi Operator    guibg=bg    guifg=#FFA927      ctermbg=6   ctermfg=15
hi Keyword     guibg=bg    guifg=#FFA927      ctermbg=bg  ctermfg=10
hi Exception   guibg=bg    guifg=#DB4B3F      ctermbg=bg  ctermfg=10

hi PreProc    guibg=bg   guifg=#ffcc99   ctermbg=4  ctermfg=14
hi Include    guibg=bg   guifg=#FFC48C   ctermbg=bg ctermfg=10
hi link Define    Include
hi link Macro     Include
hi link PreCondit Include

hi Type       guibg=bg   guifg=#FFC48C      ctermbg=bg  ctermfg=12
hi StorageClass   guibg=bg   guifg=#DB4B3F      ctermbg=bg  ctermfg=10
hi Structure      guibg=bg   guifg=#DEDEDE      ctermbg=bg  ctermfg=10
hi Typedef    guibg=bg   guifg=#FFC48C    ctermbg=bg  ctermfg=10

hi Special    guibg=bg   guifg=#bbddff      ctermbg=1   ctermfg=15
hi SpecialChar    guibg=bg   guifg=#bbddff      ctermbg=1   ctermfg=15
hi Tag        guibg=bg   guifg=#bbddff      ctermbg=1   ctermfg=15
hi Delimiter      guibg=bg   guifg=fg       ctermbg=1   ctermfg=fg
hi SpecialComment guibg=#334455  guifg=#8e8279    ctermbg=1   ctermfg=15
hi Debug      guibg=bg   guifg=#ff9999  gui=none    ctermbg=8   ctermfg=12

hi Underlined guibg=bg guifg=#99ccff gui=underline ctermbg=bg ctermfg=9 cterm=underline

hi Title    guibg=bg  guifg=#DEDEDE        ctermbg=1   ctermfg=15
hi Ignore   guibg=bg       guifg=#cccccc    ctermbg=bg  ctermfg=8
hi Error    guibg=#ff0000  guifg=white        ctermbg=12  ctermfg=15
hi Todo     guibg=#556677  guifg=#ff0000      ctermbg=1   ctermfg=12

hi htmlH2 guibg=bg guifg=fg  ctermbg=8 ctermfg=fg
hi link htmlH3 htmlH2
hi link htmlH4 htmlH3
hi link htmlH5 htmlH4
hi link htmlH6 htmlH5

set fillchars+=vert:\ 

" And finally.

let g:colors_name = "laravel"
let colors_name   = "laravel"


