function! myspacevim#before() abort
  call SpaceVim#custom#SPC('nnoremap', ['e', 'e'], ":ALEDetail<CR>", 'keyword highlight', 1)
  call SpaceVim#custom#SPC('nnoremap', ['b', 'l'], ":CtrlPBuffer<CR>", 'keyword highlight', 1)
  
  " Vim GitGutter
  let g:gitgutter_sign_added='┃'
  let g:gitgutter_sign_modified='┃'
  let g:gitgutter_sign_removed='◢'
  let g:gitgutter_sign_removed_first_line='◥'
  let g:gitgutter_sign_modified_removed='◢'
  let g:gitgutter_override_sign_column_highlight = 0
  
  " Linter
  let g:ale_linters = { 'javascript': ['eslint'] , 'python': ['flake8', 'prospector', 'vulture'] , 'haskell': ['hie'], 'go': ['go-fmt'] }
  let g:ale_haskell_hie_executable = "hie-wrapper"
  let g:ale_go_bingo_executable = "bingo"
  let g:ale_open_list = 1
  let g:ale_list_window_size = 4
  let g:ale_completion_enabled = 1
  let g:ale_lint_on_save = 1
  let g:ale_lint_on_text_changed = 1
  
  let g:ale_sign_error = ''
  let g:ale_sign_warning = ''
  
  let g:python3_host_prog = '/home/mmnanz/.pyenv/versions/neovim3/bin/python'
  let g:python_host_prog = '/home/mmnanz/.pyenv/versions/neovim2/bin/python'
  
  setlocal wrap! breakindent!
  
  noremap <Space>ghs :GitGutterStageHunk<cr>
  noremap <Space>ghr :GitGutterUndoHunk<cr>
  noremap <Space>ghv :GitGutterPreviewHunk<cr>
endfunction

function! myspacevim#after() abort
  let g:ale_sign_error = ''
  let g:ale_sign_warning = ''
  
  let g:necoghc_use_stack = 1
endfunction

