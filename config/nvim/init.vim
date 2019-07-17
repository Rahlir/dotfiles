" --------------------------Using Settings for Vim----------------------------
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc


" ----------------------NeoVim Specific Configuration-------------------------
set guicursor+=a:blinkwait700-blinkoff400-blinkon250
set noshowcmd
set nohlsearch

let g:python3_host_prog = '/anaconda3/bin/python3'

autocmd TabNewEntered * Startify


" -----------------------NeoVim Plugin Configurations-------------------------
" Nvim Matlab Options:
let g:matlab_server_launcher = 'tmux' "launch the server in a tmux split


" ---------------------------Plugin Configuration-----------------------------
" Coc Options: {{{

" use <tab> for trigger completion and navigate to the next complete item

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()
imap <silent><expr> <S-Tab> 
      \ pumvisible() ? "\<C-p>" : "<Plug>delimitMateS-Tab"

" }}}


" --------------------------------Functions-----------------------------------
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction
