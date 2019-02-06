""""""""""""""""""""""""""""""Load default vimrc""""""""""""""""""""""""""""""
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

"""""""""""""""""""""""""""neovim specific settings"""""""""""""""""""""""""""
set guicursor+=a:blinkwait700-blinkoff400-blinkon250
set noshowcmd
set nohlsearch

let g:python3_host_prog = '/anaconda3/bin/python3'

""""""""""""""""""""""""""""neovim plugin settings""""""""""""""""""""""""""""
let g:matlab_server_launcher = 'tmux' "launch the server in a tmux split

let g:UltiSnipsExpandTrigger = "<c-tab>"

" Chromatica options
let g:chromatica#enable_at_startup=1
let g:chromatica#libclang_path = '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/libclang.dylib'
let g:chromatica#responsive_mode=1

" NCM2 options
let g:ncm2#auto_popup = 0

imap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<Plug>delimitMateS-Tab"
imap <expr> <Tab> pumvisible() ? "\<C-n>" : <SID>check_back_space() ? "\<Tab>" : "\<Plug>(ncm2_manual_trigger)"

autocmd BufEnter * call ncm2#enable_for_buffer()

au User Ncm2PopupOpen set completeopt=noinsert,menuone,noselect
au User Ncm2PopupClose set completeopt=menuone

"NCM2 Pyclang options
let g:ncm2_pyclang#database_path = [
            \ 'compile_commands.json',
            \ 'build/compile_commands.json'
            \ ]
let g:ncm2_pyclang#library_path = '/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib'
autocmd FileType c,cpp nnoremap <buffer> gd :<c-u>call ncm2_pyclang#goto_declaration()<cr>

""""""""""""""""""""""""""""""""""Functions"""""""""""""""""""""""""""""""""""
function! s:check_back_space() abort ""
	let col = col('.') - 1
	return !col || getline('.')[col - 1] =~ '\s' 
endfunction ""
