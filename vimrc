" Plug Section: {{{

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')
 
Plug 'tpope/vim-sensible'
Plug 'lervag/vimtex', {'for': 'latex'}
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'davidhalter/jedi-vim', {'for': 'python'}
" Plug 'ericpruitt/tmux.vim', {'rtp': 'vim/'}
Plug 'christoomey/vim-tmux-navigator'
Plug 'w0rp/ale'
Plug 'raimondi/delimitmate'
Plug 'chriskempson/base16-vim'
Plug 'rizzatti/dash.vim'
Plug 'morhetz/gruvbox'
" Plug 'yggdroot/indentline'
" Plug 'jeetsukumaran/vim-indentwise'
" Plug 'nathanaelkane/vim-indent-guides'
Plug 'Vimjas/vim-python-pep8-indent', {'for': 'python'}
Plug 'SirVer/ultisnips'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle'  }
Plug 'dearrrfish/vim-applescript', {'for': 'applescript' }
Plug 'davidoc/taskpaper.vim', {'for': 'taskpaper'}
Plug 'leafgarland/typescript-vim', {'for': 'typescript'}
" Plug 'rip-rip/clang_complete', {'for': 'cpp'}
Plug 'majutsushi/tagbar'
" Plug 'xolox/vim-easytags'
Plug 'ryanoasis/vim-devicons'
Plug 'tpope/vim-surround'

if has('nvim')
  Plug 'arakashic/chromatica.nvim', {'for': 'cpp', 'do': ':UpdateRemotePlugins'}
  Plug 'numirias/semshi', {'for': 'python', 'do': ':UpdateRemotePlugins'}
  " Plug 'daeyun/vim-matlab', {'for': 'matlab'}
  Plug 'rahlir/nvim-matlab', {'for': 'matlab'}
  Plug 'roxma/nvim-yarp'
  Plug 'ncm2/ncm2'
  Plug 'ncm2/ncm2-bufword'
  Plug 'ncm2/ncm2-path'
  Plug 'ncm2/ncm2-pyclang', {'for': 'cpp'}
else
  Plug 'ervandew/supertab'
endif

call plug#end()

" }}}

" ---------------------------General Vim Settings-----------------------------
" Different Vim Versions Compatibility: {{{

if !has('gui_running') && !has('nvim')
  " set clipboard=exclude:.* " Turn off server for terminal vim
  let g:vimtex_compiler_latexmk = {'callback' : 0}
  if &term =~# '^tmux'
  " Without this setting terminal vim doesn't display true colors with tmux
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endif
endif

if !has('nvim')
  " Fixing python3 setting, only for brew vim
  if has('python3') && has('mac')
      command! -nargs=1 Py py3 <args>
      set pythonthreedll=/usr/local/Frameworks/Python.framework/Versions/3.7/Python
      set pythonthreehome=/usr/local/Frameworks/Python.framework/Versions/3.7
  endif
endif

" }}}
" Syntax And Colors: {{{

let g:colorscheme_setup = 'gruvbox'
set termguicolors
syntax on

if g:colorscheme_setup == 'base16'
  if filereadable(expand("~/.vimrc_background"))
    let base16colorspace=256
    source ~/.vimrc_background
  endif
elseif g:colorscheme_setup == 'gruvbox'
  colorscheme gruvbox
  let g:gruvbox_contrast_dark = 'medium'
  let g:gruvbox_italic = 1
  let g:gruvbox_italicize_strings = 1
  set background=dark
endif

" }}}
" Configurations: {{{

" Set Configurations:

set number lbr laststatus=2 title ruler mouse=a
set shiftwidth=4 tabstop=4 softtabstop=4 expandtab " Tab indentation
set noshowmode " Don't show -- INSERT --
set autochdir " Automatically change directory to file being editted
set report=0 " Report any line yanked
set spelllang=en_us " Set spelling language
set splitright splitbelow " More natural splits
set guioptions-=rL
set hidden
set completeopt+=longest
set fdm=marker
set modeline
set cursorline " Highlight the current line of cursor

" Custom Mappings:

nmap <C-p> O<Esc>
nmap <CR> o<Esc>
nmap <silent> <leader>j <Plug>(ale_next)
nmap <silent> <leader>k <Plug>(ale_previous)
nnoremap ÷ :call CenterComment()<CR>
nnoremap <leader>s :set hlsearch!<CR>
nnoremap <leader>w :call RemLdWs()<CR>
nnoremap <leader>a :setlocal spell!<CR>
nnoremap ]a }kA
nnoremap [a {jI
noremap + :call BlockComment()<CR>
noremap - :call UnBlockComment()<CR>
nnoremap <leader>b :b #<CR>

" Other:

let g:changelog_username = 'Tadeas Uhlir <tadeas.uhlir.19@dartmouth.edu>'

" }}}

" ------------------------------Plugin Options--------------------------------
" Vimtex Options: {{{

let g:tex_flavor = 'latex'
let g:vimtex_view_method = 'skim'
let g:tex_comment_nospell = 1

" }}}
" GitGutter Options: {{{
let g:gitgutter_sign_added = "\u271a"
let g:gitgutter_sign_modified = "\u279c"
let g:gitgutter_sign_removed = "\u2718"
" }}}
" Lightline Options: {{{

let g:lightline = {
      \ 'colorscheme': 'gruvbox',
			\ 'active': {
			\ 'left': [['mode', 'paste'],
			\					['gitadd', 'gitmod', 'gitremoved', 'gitbranch', 'readonly', 'filename', 'modified']]
			\ },
			\ 'component_function': {
			\		'gitbranch': 'LightLineGitBranch',
      \   'filetype': 'MyFiletype',
      \   'fileformat': 'MyFileformat',
			\ },
			\ 'component_expand': {
			\		'gitadd': 'LightLineGitAdd',
			\		'gitmod': 'LightLineGitMod',
			\		'gitremoved': 'LightLineGitRemoved'
			\	},
			\ 'component_type': {
			\		'gitadd': 'good',
			\		'gitmod': 'warning',
			\		'gitremoved': 'error'
			\		}
      \ }

function! MyFiletype()
	if exists('*WebDevIconsGetFileTypeSymbol')
		return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
	else
		return &filetype
	endif
endfunction

function! MyFileformat()
	if exists('*WebDevIconsGetFileFormatSymbol')
		return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
	else
		return &fileformat
	endif
endfunction

function! LightLineGitAdd()
  if exists('*GitGutterGetHunkSummary') && !empty(LightLineGitBranch())
    let [ added, modified, removed ] = GitGutterGetHunkSummary()
    return printf('%s %d', g:gitgutter_sign_added, added)
  endif
  return ''
endfunction

function! LightLineGitMod()
  if exists('*GitGutterGetHunkSummary') && !empty(LightLineGitBranch())
    let [ added, modified, removed ] = GitGutterGetHunkSummary()
    return printf('%s %d', g:gitgutter_sign_modified, modified)
  endif
  return ''
endfunction

function! LightLineGitRemoved() 
  if exists('*GitGutterGetHunkSummary') && !empty(LightLineGitBranch())
    let [ added, modified, removed ] = GitGutterGetHunkSummary()
    return printf('%s %d', g:gitgutter_sign_removed, removed)
  endif
  return ''
endfunction

function! LightLineGitBranch()
  if exists('*fugitive#head')
    let branch = fugitive#head()
    return branch !=# '' ? '⭠ '.branch : ''
  endif
  return ''
endfunction

autocmd User GitGutter call lightline#update()

" }}}
" DelimitMate Options: {{{

let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1

" }}}
" SuperTab Options: {{{

let g:SuperTabDefaultCompletionType = 'context'
let g:SuperTabCrMapping = 0
let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
let g:SuperTabContextTextOmniPrecedence = ['&omnifunc', '&completefunc']
let g:SuperTabContextDiscoverDiscovery =
    \ ["&omnifunc:<c-x><c-o>", "&completefunc:<c-x><c-u>"]
let g:SuperTabMappingBackward = '<s-c-space>'

" }}}
" ALE Options: {{{

let g:ale_linters = {
      \   'python': ['autopep8', 'flake8'],
      \   'cpp': ['gcc']
      \}
let g:ale_c_parse_compile_commands = '1'
let g:ale_cpp_clang_options = '-std=c++14 -Wall -isystem /Applications/XCode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1'
let g:ale_cpp_gcc_options = '-std=c++14 -Wall -isystem /Applications/XCode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/include/c++/v1'

" }}}
" UltiSnips Options: {{{

let g:UltiSnipsSnippetDirectories = ['~/.vim/UltiSnips', 'UltiSnips']

" }}}
" Jedi Options: {{{

let g:jedi#popup_select_first = 0
let g:jedi#popup_on_dot = 0
let g:jedi#show_call_signatures = "2"
let g:jedi#use_splits_not_buffers = "top"

" }}}
" Indent_guides  Options: {{{

let g:indent_guides_auto_colors = 0
let g:indent_guides_guide_size = 1
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=240
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=235

" }}}

" -------------------------Filetype Specific Config---------------------------
" Python Latex Matlab: {{{
" Python: 

autocmd FileType python setlocal completeopt-=preview


" Latex

au FileType tex let b:delimitMate_quotes = "\" ' ` $"
au FileType tex let b:delimitMate_smart_matchpairs = '^\%(\w\|\!\|£\|[^[:space:][:punct:]]\)'
au FileType tex setlocal tw=79

" Matlab

au FileType matlab inoremap <buffer> <C-p> <C-o>A;
au FileType matlab setlocal commentstring=%%s 

" }}}

" --------------------------------Functions-----------------------------------
" Mappable Functions: {{{

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

function! CenterComment()
  let a:cmnt_raw = split(&commentstring, '%s')[0]
  let a:cmnt = substitute(a:cmnt_raw, ' ', '', '')

  let a:del_str = '-'

  if &tw != 0
    let a:width = &tw
  else
    let a:width = 80
  endif

  let a:header = getline(".")
  let a:header_w = strlen(a:header)
  let a:before_w = (a:width - a:header_w) / 2
  let a:after_w = (a:width - a:header_w - a:before_w)
  let a:before = a:cmnt . ' ' . repeat(a:del_str, a:before_w-2)
  let a:after = repeat(a:del_str, a:after_w)

  call setline(".", a:before . a:header . a:after)
endfunc

" }}}
" Debugging Functions: {{{

function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
" }}}
