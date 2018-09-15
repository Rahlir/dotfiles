" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'tpope/vim-sensible'
Plug 'lervag/vimtex'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'davidhalter/jedi-vim'
" Plug 'ericpruitt/tmux.vim', {'rtp': 'vim/'}
Plug 'ervandew/supertab'
Plug 'christoomey/vim-tmux-navigator'
Plug 'w0rp/ale'
Plug 'raimondi/delimitmate'
" Plug 'chriskempson/base16-vim'
Plug 'rizzatti/dash.vim'
" Plug 'yggdroot/indentline'
Plug 'jeetsukumaran/vim-indentwise'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'SirVer/ultisnips'
Plug 'scrooloose/nerdtree'
Plug 'dearrrfish/vim-applescript'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

if !has('gui_running')
	set clipboard=exclude:.*
	let g:vimtex_compiler_latexmk = {'callback' : 0}
endif

" Vimtex options
let g:tex_flavor = 'latex'
let g:vimtex_view_method = 'skim'
" Not possible without matchup:
" let g:matchup_matchparen_deferred = 1
let g:tex_comment_nospell = 1

syntax on
let python_highlight_all = 1

" Configurations for vim
set number lbr laststatus=2 title hlsearch ruler mouse=a
set shiftwidth=2 tabstop=2 " Tab indentation
set noshowmode " Don't show -- INSERT --
set autochdir " Automatically change directory to file being editted
set report=0 " Report any line yanked
set spelllang=en_us " Set spelling language
set splitright splitbelow " More natural splits
set guioptions-=rL

" Colorscheme setting
if filereadable(expand("~/.vimrc_background"))
	let base16colorspace=256
	source ~/.vimrc_background
endif

if has('python3')
    command! -nargs=1 Py py3 <args>
    set pythonthreedll=/usr/local/Frameworks/Python.framework/Versions/3.7/Python
    set pythonthreehome=/usr/local/Frameworks/Python.framework/Versions/3.7
endif

" Custom mappings
nmap <C-p> O<Esc>
nmap <CR> o<Esc>
nmap <silent> <leader>j <Plug>(ale_next)
nmap <silent> <leader>k <Plug>(ale_previous)
nnoremap <leader>s :nohlsearch<CR>
nnoremap <leader>w :call RemLdWs()<CR>
nnoremap <leader>a :setlocal spell!<CR>
nnoremap ]a }kA
nnoremap [a {jI

let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ }

let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabCrMapping = 1

let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
let g:SuperTabContextDiscoverDiscovery =
		\ ["&omnifunc:<c-x><c-o>", "&completefunc:<c-x><c-u>"]

let g:SuperTabMappingBackward = '<s-c-space>'

let g:ale_linters = {
			\   'python': ['autopep8', 'flake8']
			\}
let g:UltiSnipsSnippetDirectories = ['~/.vim/UltiSnips', 'UltiSnips']

let g:indent_guides_auto_colors = 0
let g:indent_guides_guide_size = 1
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=240
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=235

set completeopt+=longest

"-----------Filetype Specific Config------------
" Python
let g:jedi#popup_select_first = 0
let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = "2"
let g:jedi#use_splits_not_buffers = "top"
autocmd FileType python setlocal completeopt-=preview
autocmd FileType python noremap <buffer> + :call BlockComment("#")<CR>
autocmd FileType python noremap <buffer> - :call UnBlockComment("#")<CR>

" Vim
autocmd FileType vim noremap <buffer> + :call BlockComment("\"")<CR>
autocmd FileType vim noremap <buffer> - :call UnBlockComment("\"")<CR>

" LAMMPS
autocmd FileType lammps noremap <buffer> + :call BlockComment("#")<CR>
autocmd FileType lammps noremap <buffer> - :call UnBlockComment("#")<CR>

" Shell
autocmd FileType sh noremap <buffer> + :call BlockComment("#")<CR>
autocmd FileType sh noremap <buffer> - :call UnBlockComment("#")<CR>

" Latex
au FileType tex let b:delimitMate_quotes = "\" ' $"
au FileType tex noremap <buffer> + :call BlockComment("%")<CR>
au Filetype tex noremap <buffer> - :call UnBlockComment("%")<CR>

" Matlab
au FileType matlab noremap <buffer> + :call BlockComment("%")<CR>
au Filetype matlab noremap <buffer> - :call UnBlockComment("%")<CR>

" Javascript
au FileType javascript let g:delimitMate_expand_cr = 1
au FileType javascript let g:delimitMate_expand_space = 1
let g:delimitMate_expand_space = 1


function! BlockComment(cmnt)
	exe ':silent s/^\(\s*\)/\1' . a:cmnt . ' /'
	nohlsearch
endfunction

function! UnBlockComment(cmnt)
	exe ':silent s/^\(\s*\)' . a:cmnt .  ' /\1/e'
	nohlsearch
endfunction

function! RemLdWs()
	exe 's/\s\+$//e'
	nohlsearch
endfunction

function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
