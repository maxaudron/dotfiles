"*****************************************************************************
"" Vim-PLug core
"*****************************************************************************
if has('vim_starting')
  set nocompatible               " Be iMproved
endif

let vimplug_exists=expand('~/.config/nvim/autoload/plug.vim')

let g:vim_bootstrap_langs = "html,javascript"
let g:vim_bootstrap_editor = "nvim"				" nvim or vim

if !filereadable(vimplug_exists)
  echo "Installing Vim-Plug..."
  echo ""
  silent !\curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif

function g:WorkspaceSetCustomColors()
  highlight WorkspaceBufferCurrent cterm=NONE ctermbg=00 ctermfg=11 guibg=#181818 guifg=#E88A30
  highlight WorkspaceBufferActive cterm=NONE ctermbg=00 ctermfg=11 guibg=#181818 guifg=#E88A30
  highlight WorkspaceBufferHidden cterm=NONE ctermbg=00 ctermfg=8 guibg=#181818 guifg=#626262
  highlight WorkspaceBufferTrunc cterm=NONE ctermbg=00 ctermfg=11 guibg=#181818 guifg=#000000
  highlight WorkspaceTabCurrent cterm=NONE ctermbg=00 ctermfg=11 guibg=#181818 guifg=#000000
  highlight WorkspaceTabHidden cterm=NONE ctermbg=00 ctermfg=19 guibg=#181818 guifg=#000000
  highlight WorkspaceFill cterm=NONE ctermbg=00 ctermfg=10 guibg=#181818 guifg=#000000
endfunction 

" Required:
call plug#begin(expand('~/.config/nvim/plugged'))

"*****************************************************************************
"" Plug install packages
"*****************************************************************************

" General
Plug 'ctrlpvim/ctrlp.vim'

" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'

Plug 'easymotion/vim-easymotion'

" Completion and Linting
Plug 'maralla/completor.vim'
Plug 'w0rp/ale'
Plug 'Raimondi/delimitMate'

" Aligning / Matching / Other tools
Plug 'Valloric/MatchTagAlways'
Plug 'Yggdroot/indentLine'
Plug 'tpope/vim-surround'                               " Tag manipulation
Plug 'godlygeek/tabular'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-commentary'

" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'Quramy/vim-js-pretty-template'

Plug 'leafgarland/typescript-vim'
Plug 'Quramy/tsuquyomi'

" Bufferbar and Statusbar and other visuals
Plug 'bagrat/vim-workspace'
Plug 'chrisbra/Colorizer'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdtree'

" Tags
Plug 'xolox/vim-easytags'
Plug 'xolox/vim-misc'
Plug 'majutsushi/tagbar'

Plug 'editorconfig/editorconfig-vim'

Plug 'lervag/vimtex'

Plug 'neovimhaskell/haskell-vim'
Plug 'eagletmt/neco-ghc'


call plug#end()

"*****************************************************************************
"" SETings
"*****************************************************************************

"let base16colorspace=256
"colorscheme base16-tomorrow-night

colorscheme laravel
" set fillchars+=vert:\ 
" Set Python enviroment
let g:python3_host_prog = '/home/mmnanz/.pyenv/versions/neovim3/bin/python'
let g:completor_python_binary = '/home/mmnanz/.pyenv/versions/neovim3/bin/python'

let g:enable_bold_font = 1
let g:enable_italic_font = 1

syntax on

set mouse=a
set number
set laststatus=2
set noshowmode
set cursorline
set backspace=indent,eol,start
set ignorecase
set smartcase
set incsearch
set hlsearch
set undofile                 		" maintaion undo history
set showcmd
set updatetime=250
set hidden 

set termguicolors

" Spaceing
set shiftwidth=2  " indent = 4 spaces
set tabstop=2	  " tab    = 4 spaces
set softtabstop=2 " backspace through spaces
set expandtab   " tabs are tabs

" Linter
let b:ale_linters = { 'javascript': ['eslint'] , 'python': ['flake8', 'prospector', 'vulture'] , 'haskell': ['brittany', 'stack-ghc'] }
let g:ale_open_list = 1
let g:ale_list_window_size = 4

let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0

let g:ale_sign_error = '┃'
let g:ale_sign_warning = '┃'



highlight ALEErrorSign guibg=NONE guifg=#D52B1D
highlight ALEWarningSign guibg=NONE guifg=#E88A30

" TypeScript
let g:typescript_compiler_binary = 'tsc'
let g:typescript_compiler_options = ''
autocmd QuickFixCmdPost [^l]* nested cwindow
autocmd QuickFixCmdPost    l* nested lwindow

autocmd FileType typescript JsPreTmpl html
autocmd FileType typescript syn clear foldBraces

" Snippets
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"

"let g:UltiSnipsExpandTrigger = "<nop>"
"let g:ulti_expand_or_jump_res = 0
"function ExpandSnippetOrCarriageReturn()
"    let snippet = UltiSnips#ExpandSnippetOrJump()
"    if g:ulti_expand_or_jump_res > 0
"        return snippet
"    else
"        return "\<CR>"
"    endif
"endfunction
"inoremap <expr> <CR> pumvisible() ? "<C-R>=ExpandSnippetOrCarriageReturn()<CR>" : "\<CR>"

" Vim GitGutter
let g:gitgutter_sign_added='┃'
let g:gitgutter_sign_modified='┃'
let g:gitgutter_sign_removed='◢'
let g:gitgutter_sign_removed_first_line='◥'
let g:gitgutter_sign_modified_removed='◢'

let g:vimtex_view_general_viewer = 'zathura'
let g:vimtex_compiler_method = 'latexmk'

" Vim Workspace
let g:workspace_powerline_separators = 0
let g:workspace_tab_icon = " "
let g:workspace_separator = " "
let g:workspace_subseparator = " "

""""""""""""""""""""""""""""""
" Status line
""""""""""""""""""""""""""""""
let g:currentmode={
      \ 'n'  : 'NORMAl ',
      \ 'no' : 'N·Operator Pending ',
      \ 'v'  : 'VISUAL ',
      \ 'V'  : 'V·Line ',
      \ '' : 'V·Block',
      \ 's'  : 'Select ',
      \ 'S'  : 'S·Line ',
      \ '' : 'S·Block',
      \ 'i'  : 'INSERT ',
      \ 'R'  : 'REPLACE ',
      \ 'Rv' : 'V·Replace ',
      \ 'c'  : 'Command ',
      \ 'cv' : 'Vim Ex ',
      \ 'ce' : 'Ex ',
      \ 'r'  : 'Prompt ',
      \ 'rm' : 'More ',
      \ 'r?' : 'Confirm ',
      \ '!'  : 'SHELL ',
      \ 't'  : 'TERMINAL '}

hi clear StatusLine
hi clear StatusLineNC
hi clear TabLine
hi StatusLine                  ctermbg=0 guibg=#181818 guifg=#626262
hi TabLine                     ctermbg=0 guibg=#181818 guifg=#626262
hi StatusLineNC                ctermbg=10 guibg=#181818 guifg=#f5f5f5

set statusline=
set statusline+=\ %{g:currentmode[mode()]}
set statusline+=%#StatusLineNC#
set statusline+=%m
set statusline+=%= 
set statusline+=%#TabLine#
set statusline+=%{LinterStatus()}
set statusline+=%*
set statusline+=%#TabLine#
set statusline+=\ %{GitInfo()}
set statusline+=\ %l\ %c

function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi statusline guibg=#181818 ctermfg=10 guifg=#E88A30 ctermbg=0
  elseif a:mode == 'v'
    hi statusline guibg=#181818 ctermfg=10 guifg=#5793e0 ctermbg=0
  elseif a:mode == 't'
    hi statusline guibg=#181818 ctermfg=White guifg=#DB4B3F ctermbg=0
  else
    hi statusline guibg=#181818 ctermfg=1 guifg=#626262 ctermbg=0
  endif
endfunction

au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi statusline guibg=#181818 ctermfg=DarkGray guifg=#626262 ctermbg=0

" Error and warning count
function! LinterStatus() abort
    let l:counts = ale#statusline#Count(bufnr(''))

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return l:counts.total == 0 ? 'OK ' : printf(
    \   '%dW %dE',
    \   all_non_errors,
    \   all_errors
    \)
endfunction

" Statusline Functions
function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! GitInfo()
  let git = fugitive#head()
  if git != ''
    return ' '.fugitive#head()
  else
    return ''
  endfunction

"""""""""""""""""""""""
" Haskell Tags
let g:tagbar_type_haskell = {
    \ 'ctagsbin'  : 'hasktags',
    \ 'ctagsargs' : '-x -c -o-',
    \ 'kinds'     : [
        \  'm:modules:0:1',
        \  'd:data: 0:1',
        \  'd_gadt: data gadt:0:1',
        \  't:type names:0:1',
        \  'nt:new types:0:1',
        \  'c:classes:0:1',
        \  'cons:constructors:1:1',
        \  'c_gadt:constructor gadt:1:1',
        \  'c_a:constructor accessors:1:1',
        \  'ft:function types:1:1',
        \  'fi:function implementations:0:1',
        \  'o:others:0:1'
    \ ],
    \ 'sro'        : '.',
    \ 'kind2scope' : {
        \ 'm' : 'module',
        \ 'c' : 'class',
        \ 'd' : 'data',
        \ 't' : 'type'
    \ },
    \ 'scope2kind' : {
        \ 'module' : 'm',
        \ 'class'  : 'c',
        \ 'data'   : 'd',
        \ 'type'   : 't'
    \ }
\ }


  "*****************************************************************************
  "" Abbreviations
  "*****************************************************************************
  "" no one is really happy until you have this shortcuts
  cnoreabbrev W! w!
  cnoreabbrev Q! q!
  cnoreabbrev Qall! qall!
  cnoreabbrev Wq wq
  cnoreabbrev Wa wa
  cnoreabbrev wQ wq
  cnoreabbrev WQ wq
  cnoreabbrev W w
  cnoreabbrev Q q
  cnoreabbrev Qall qall

  "" NERDTree configuration
  let g:NERDTreeChDirMode=2
  let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
  let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
  let g:NERDTreeShowBookmarks=1
  let g:nerdtree_tabs_focus_on_files=1
  let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
  let g:NERDTreeWinSize = 50
  set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite
  nnoremap <silent> <F2> :NERDTreeFind<CR>
  noremap <F3> :NERDTreeToggle<CR>

  " autoclose nerdtree if it is the only open buffer
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

  " terminal emulation
  if g:vim_bootstrap_editor == 'nvim'
    nnoremap <silent> <leader>sh :terminal<CR>
  else
    nnoremap <silent> <leader>sh :VimShellCreate<CR>
  endif

  "*****************************************************************************
  "" Functions
  "*****************************************************************************
  if !exists('*s:setupWrapping')
    function s:setupWrapping()
      set wrap
      set wm=2
      set textwidth=79
    endfunction
  endif

  "*****************************************************************************
  "" Autocmd Rules
  "*****************************************************************************
  "" The PC is fast enough, do syntax highlight syncing from start unless 200 lines
  augroup vimrc-sync-fromstart
    autocmd!
    autocmd BufEnter * :syntax sync maxlines=200
  augroup END

  "" Remember cursor position
  augroup vimrc-remember-cursor-position
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
  augroup END

  "" txt
  augroup vimrc-wrapping
    autocmd!
    autocmd BufRead,BufNewFile *.txt call s:setupWrapping()
  augroup END

  "" make/cmake
  augroup vimrc-make-cmake
    autocmd!
    autocmd FileType make setlocal noexpandtab
    autocmd BufNewFile,BufRead CMakeLists.txt setlocal filetype=cmake
  augroup END

  set autoread

  "*****************************************************************************
  "" Mappings
  "*****************************************************************************

  "" Split
  noremap <Leader>h :<C-u>split<CR>
  noremap <Leader>v :<C-u>vsplit<CR>

  "" Git
  noremap <Leader>ga :Gwrite<CR>
  noremap <Leader>gc :Gcommit<CR>
  noremap <Leader>gsh :Gpush<CR>
  noremap <Leader>gll :Gpull<CR>
  noremap <Leader>gs :Gstatus<CR>
  noremap <Leader>gb :Gblame<CR>
  noremap <Leader>gd :Gvdiff<CR>
  noremap <Leader>gr :Gremove<CR>

  " session management
  nnoremap <leader>so :OpenSession<Space>
  nnoremap <leader>ss :SaveSession<Space>
  nnoremap <leader>sd :DeleteSession<CR>
  nnoremap <leader>sc :CloseSession<CR>

  "" Tabs
  nnoremap <leader><Tab> gt
  nnoremap <leader><S-Tab> gT
  nnoremap <silent> <S-t> :tabnew<CR>

  "" Set working directory
  nnoremap <leader>. :lcd %:p:h<CR>

  "" Opens an edit command with the path of the currently edited file filled in
  noremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

  "" Opens a tab edit command with the path of the currently edited file filled
  noremap <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

  "" ctrlp.vim
  set wildmode=list:longest,list:full
  set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
  let g:ctrlp_custom_ignore = '\v[\/](node_modules|target|dist)|(\.(swp|tox|ico|git|hg|svn))$'
  let g:ctrlp_user_command = "find %s -type f | grep -Ev '"+ g:ctrlp_custom_ignore +"'"
  let g:ctrlp_use_caching = 1

  " The Silver Searcher
  if executable('ag')
    set grepprg=ag\ --nogroup\ --nocolor
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
    let g:ctrlp_use_caching = 0
  endif

  cnoremap <C-P> <C-R>=expand("%:p:h") . "/" <CR>
  noremap <leader>b :CtrlPBuffer<CR>
  let g:ctrlp_map = '<leader>e'
  let g:ctrlp_open_new_file = 'r'
  let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'

  " snippets
  let g:UltiSnipsExpandTrigger="<tab>"
  let g:UltiSnipsJumpForwardTrigger="<tab>"
  let g:UltiSnipsJumpBackwardTrigger="<c-b>"
  let g:UltiSnipsEditSplit="vertical"

  " Tagbar
  nmap <silent> <F4> :TagbarToggle<CR>
  let g:tagbar_autofocus = 1

  " Disable visualbell
  set noerrorbells visualbell t_vb=
  if has('autocmd')
    autocmd GUIEnter * set visualbell t_vb=
  endif

  "" Copy/Paste/Cut
  if has('unnamedplus')
    set clipboard=unnamed,unnamedplus
  endif

  noremap YY "+y<CR>
  noremap <leader>p "+gP<CR>
  noremap XX "+x<CR>

  if has('macunix')
    " pbcopy for OSX copy/paste
    vmap <C-x> :!pbcopy<CR>
    vmap <C-c> :w !pbcopy<CR><CR>
  endif

  "" Buffer nav
  noremap <leader>z :bp<CR>
  noremap <leader>q :bp<CR>
  noremap <leader>x :bn<CR>
  noremap <leader>w :bn<CR>

  "" Close buffer
  noremap <leader>c :bd<CR>

  "" Clean search (highlight)
  nnoremap <silent> <leader><space> :noh<cr>

  "" Switching windows
  noremap <C-j> <C-w>j
  noremap <C-k> <C-w>k
  noremap <C-l> <C-w>l
  noremap <C-h> <C-w>h

  "" Vmap for maintain Visual Mode after shifting > and <
  vmap < <gv
  vmap > >gv

  "" Move visual block
  vnoremap J :m '>+1<CR>gv=gv
  vnoremap K :m '<-2<CR>gv=gv

  "" Open current line on GitHub
  nnoremap <Leader>o :.Gbrowse<CR>

  "*****************************************************************************
  "" Custom configs
  "*****************************************************************************



  "*****************************************************************************
  "*****************************************************************************



  "*****************************************************************************
  "" Convenience variables
  "*****************************************************************************


