" --------------------------Using Settings for Vim----------------------------
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc


" ----------------------NeoVim Specific Configuration-------------------------
set guicursor+=a:blinkwait700-blinkoff400-blinkon250
set noshowcmd
set nohlsearch

let g:python3_host_prog = '$HOME/anaconda3/bin/python3'


" -----------------------NeoVim Plugin Configurations-------------------------
" Nvim Matlab Options:
let g:matlab_server_launcher = 'tmux' " launch the server in a tmux split


" ---------------------------Plugin Configuration-----------------------------
" Coc Options: {{{

" Use <tab> for trigger completion and navigate to the next complete item
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()
imap <silent><expr> <S-Tab> 
      \ pumvisible() ? "\<C-p>" : "<Plug>delimitMateS-Tab"

nnoremap <silent> <leader>K :call CocActionAsync('doHover')<cr>
nnoremap <silent> <leader>g :call CocActionAsync('showSignatureHelp')<cr>
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

" I am not sure why this should be shorter in neovim but I read it somewhere.
" I think this has got to do something with preview windows and/or LSP
set updatetime=300
" }}}


" --------------------------------Functions-----------------------------------
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction
