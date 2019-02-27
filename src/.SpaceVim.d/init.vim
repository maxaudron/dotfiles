"=============================================================================
" init.vim --- Entry file for neovim
" Copyright (c) 2016-2017 Wang Shidong & Contributors
" Author: Wang Shidong < wsdjeg at 163.com >
" URL: https://spacevim.org
" License: GPLv3
"=============================================================================


" Vim GitGutter
let g:gitgutter_sign_added='┃'
let g:gitgutter_sign_modified='┃'
let g:gitgutter_sign_removed='◢'
let g:gitgutter_sign_removed_first_line='◥'
let g:gitgutter_sign_modified_removed='◢'

let g:python3_host_prog = '/home/mmnanz/.pyenv/versions/neovim3/bin/python'
let g:python_host_prog = '/home/mmnanz/.pyenv/versions/neovim2/bin/python'

execute 'source' fnamemodify(expand('<sfile>'), ':h').'/config/main.vim'
