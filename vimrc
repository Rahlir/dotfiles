" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'tpope/vim-sensible'
Plug 'lervag/vimtex'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'davidhalter/jedi-vim'
Plug 'ericpruitt/tmux.vim', {'rtp': 'vim/'}
Plug 'ervandew/supertab'
Plug 'christoomey/vim-tmux-navigator'
Plug 'w0rp/ale'
Plug 'raimondi/delimitmate'
let g:vimtex_version_check = 0

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

syntax on

" Configurations for vim
set number lbr laststatus=2 title hlsearch ruler mouse=a
set shiftwidth=2 tabstop=2 " Tab indentation
set noshowmode " Don't show -- INSERT --
set autochdir " Automatically change directory to file being editted

" Colorscheme setting
if filereadable(expand("~/.vimrc_background"))
	let base16colorspace=256
	source ~/.vimrc_background
endif

" Custom mappings
nmap <C-p> O<Esc>
nmap <CR> o<Esc>
nnoremap <leader>s :nohlsearch<CR>

let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ }

let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
let g:SuperTabCrMapping = 1

let g:ale_linters = {
			\   'python': ['autopep8', 'flake8']
			\}

set completeopt+=longest

"-----------Filetype Specific Config------------
" Python
let g:jedi#popup_select_first = 0
let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = "2"
let g:jedi#use_splits_not_buffers = "top"
autocmd FileType python setlocal completeopt-=preview
autocmd FileType python noremap + :call BlockComment("#")<CR>
autocmd FileType python noremap - :call UnBlockComment("#")<CR>

" Vim
autocmd FileType vim noremap + :call BlockComment("\"")<CR>
autocmd FileType vim noremap - :call UnBlockComment("\"")<CR>

" LAMMPS
autocmd FileType lammps noremap + :call BlockComment("#")<CR>
autocmd FileType lammps noremap - :call UnBlockComment("#")<CR>

" Shell
autocmd FileType sh noremap + :call BlockComment("#")<CR>
autocmd FileType sh noremap - :call UnBlockComment("#")<CR>
	

function BlockComment(cmnt)
	exe 's/^/' . a:cmnt . ' /'
	nohlsearch
endfunction

function UnBlockComment(cmnt)
	exe 's/^' . a:cmnt . ' //'
	nohlsearch
endfunction
