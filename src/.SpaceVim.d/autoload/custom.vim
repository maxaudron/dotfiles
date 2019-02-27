function! myspacevim#before() abort
  " Vim GitGutter
  let g:gitgutter_sign_added='┃'
  let g:gitgutter_sign_modified='┃'
  let g:gitgutter_sign_removed='◢'
  let g:gitgutter_sign_removed_first_line='◥'
  let g:gitgutter_sign_modified_removed='◢'

  " Linter
  let b:ale_linters = { 'javascript': ['eslint'] , 'python': ['flake8', 'prospector', 'vulture'] , 'haskell': ['brittany', 'stack-ghc'] }
  let g:ale_open_list = 1
  let g:ale_list_window_size = 4
  
  let g:ale_lint_on_save = 1
  let g:ale_lint_on_text_changed = 0
  
  let g:ale_sign_error = ''
  let g:ale_sign_warning = ''
  
  let g:python3_host_prog = '/home/mmnanz/.pyenv/versions/neovim3/bin/python'
  let g:python_host_prog = '/home/mmnanz/.pyenv/versions/neovim2/bin/python'
endfunction

function! myspacevim#after() abort
   " Vim GitGutter
  let g:gitgutter_sign_added='┃'
  let g:gitgutter_sign_modified='┃'
  let g:gitgutter_sign_removed='◢'
  let g:gitgutter_sign_removed_first_line='◥'
  let g:gitgutter_sign_modified_removed='◢'

  " Linter
  let b:ale_linters = { 'javascript': ['eslint'] , 'python': ['flake8', 'prospector', 'vulture'] , 'haskell': ['brittany', 'stack-ghc'] }
  let g:ale_open_list = 1
  let g:ale_list_window_size = 4
  
  let g:ale_lint_on_save = 1
  let g:ale_lint_on_text_changed = 0
  
  let g:ale_sign_error = ''
  let g:ale_sign_warning = ''
  
  let g:python3_host_prog = '/home/mmnanz/.pyenv/versions/neovim3/bin/python'
  let g:python_host_prog = '/home/mmnanz/.pyenv/versions/neovim2/bin/python'
endfunction

