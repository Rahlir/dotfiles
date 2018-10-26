"""""""""""""""""""""""""""""""""Plug section"""""""""""""""""""""""""""""""""
" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

Plug 'tpope/vim-sensible'
Plug 'lervag/vimtex'
Plug 'itchyny/lightline.vim'
" Plug 'tpope/vim-fugitive'
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
Plug 'davidoc/taskpaper.vim'

call plug#end()


"""""""""""""""""""""""""""""General vim settings"""""""""""""""""""""""""""""
if !has('gui_running')
	set clipboard=exclude:.* " Turn off server for terminal vim
	let g:vimtex_compiler_latexmk = {'callback' : 0}
	nnoremap <C-_> :call CenterComment()<CR>
else
	nnoremap ÷ :call CenterComment()<CR>
endif

" Colorscheme setting
if filereadable(expand("~/.vimrc_background"))
	let base16colorspace=256
	source ~/.vimrc_background
endif

" Fixing python3 setting, only for brew vim
if has('python3')
    command! -nargs=1 Py py3 <args>
    set pythonthreedll=/usr/local/Frameworks/Python.framework/Versions/3.7/Python
    set pythonthreehome=/usr/local/Frameworks/Python.framework/Versions/3.7
endif

" Syntax
syntax on
" let python_highlight_all = 1

" Configurations for vim
set number lbr laststatus=2 title ruler mouse=a
set shiftwidth=2 tabstop=2 " Tab indentation
set noshowmode " Don't show -- INSERT --
set autochdir " Automatically change directory to file being editted
set report=0 " Report any line yanked
set spelllang=en_us " Set spelling language
set splitright splitbelow " More natural splits
set guioptions-=rL
set hidden
set completeopt+=longest

" Custom mappings
nmap <C-p> O<Esc>
nmap <CR> o<Esc>
nmap <silent> <leader>j <Plug>(ale_next)
nmap <silent> <leader>k <Plug>(ale_previous)
nnoremap <leader>s :set hlsearch!<CR>
nnoremap <leader>w :call RemLdWs()<CR>
nnoremap <leader>a :setlocal spell!<CR>
nnoremap ]a }kA
nnoremap [a {jI
noremap + :call BlockComment()<CR>
noremap - :call UnBlockComment()<CR>
nnoremap <leader>b :b #<CR>

let g:changelog_username = 'Tadeas Uhlir <tadeas.uhlir.19@dartmouth.edu>'

""""""""""""""""""""""""""""""""Plugin options""""""""""""""""""""""""""""""""
" Vimtex options
let g:tex_flavor = 'latex'
let g:vimtex_view_method = 'skim'
let g:tex_comment_nospell = 1
" Not possible without matchup:
" let g:matchup_matchparen_deferred = 1

" Lightline options
let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ }

" DelimitMate options
let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1

" SuperTab options
let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabCrMapping = 0
let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
let g:SuperTabContextDiscoverDiscovery =
		\ ["&omnifunc:<c-x><c-o>", "&completefunc:<c-x><c-u>"]
let g:SuperTabMappingBackward = '<s-c-space>'

" ALE options
let g:ale_linters = {
			\   'python': ['autopep8', 'flake8']
			\}

" UltiSnips options
let g:UltiSnipsSnippetDirectories = ['~/.vim/UltiSnips', 'UltiSnips']

" Jedi options
let g:jedi#popup_select_first = 0
let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = "2"
let g:jedi#use_splits_not_buffers = "top"

" Indent-Guides  options
let g:indent_guides_auto_colors = 0
let g:indent_guides_guide_size = 1
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=240
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=235


"""""""""""""""""""""""""""Filetype Specific Config"""""""""""""""""""""""""""
" Python
autocmd FileType python setlocal completeopt-=preview
" autocmd FileType python noremap <buffer> + :call BlockComment("#")<CR>
" autocmd FileType python noremap <buffer> - :call UnBlockComment("#")<CR>

" Vim
" autocmd FileType vim noremap <buffer> + :call BlockComment("\"")<CR>
" autocmd FileType vim noremap <buffer> - :call UnBlockComment("\"")<CR>
" autocmd FileType vim noremap <buffer> <C-_> :call CenterComment("\"")<CR>

" LAMMPS
" autocmd FileType lammps noremap <buffer> + :call BlockComment("#")<CR>
" autocmd FileType lammps noremap <buffer> - :call UnBlockComment("#")<CR>

" Shell
" autocmd FileType sh noremap <buffer> + :call BlockComment("#")<CR>
" autocmd FileType sh noremap <buffer> - :call UnBlockComment("#")<CR>

" Latex
au FileType tex let b:delimitMate_quotes = "\" ' ` $"
au FileType tex let b:delimitMate_smart_matchpairs = '^\%(\w\|\!\|£\|[^[:space:][:punct:]]\)'
au FileType tex setlocal tw=79
" au FileType tex noremap <buffer> + :call BlockComment("%")<CR>
" au Filetype tex noremap <buffer> - :call UnBlockComment("%")<CR>

" Matlab
" au FileType matlab noremap <buffer> + :call BlockComment("%")<CR>
" au Filetype matlab noremap <buffer> - :call UnBlockComment("%")<CR>

""""""""""""""""""""""""""""""""""Functions"""""""""""""""""""""""""""""""""""
function! BlockComment()
	let a:cmnt_raw = split(&commentstring, '%s')[0]
	let a:cmnt = substitute(a:cmnt_raw, '^\s*\(.\{-}\)\s*$', '\1', '')
	exe ':silent s/^\(\s*\)/\1' . a:cmnt . ' /'
	nohlsearch
endfunction

function! UnBlockComment()
	let a:cmnt_raw = split(&commentstring, '%s')[0]
	let a:cmnt = substitute(a:cmnt_raw, '^\s*\(.\{-}\)\s*$', '\1', '')
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

function! CenterComment()
	let a:cmnt = split(&commentstring, '%s')[0]

  if &tw != 0
    let a:width = &tw
  else
    let a:width = 80
  endif

  let a:header = getline(".")
  let a:header_w = strlen(a:header)
  let a:before_w = (a:width - a:header_w) / 2
  let a:after_w = (a:width - a:header_w - a:before_w)
  let a:before = repeat(a:cmnt, a:before_w)
  let a:after = repeat(a:cmnt, a:after_w)

  call setline(".", a:before . a:header . a:after)
endfunc
