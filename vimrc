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
Plug 'morhetz/gruvbox'
Plug 'rizzatti/dash.vim'

"Plug 'nathanaelkane/vim-indent-guides'
Plug 'yggdroot/indentline'

Plug 'Vimjas/vim-python-pep8-indent', {'for': 'python'}
Plug 'SirVer/ultisnips'
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle', 'for': 'cpp' }
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'dearrrfish/vim-applescript', {'for': 'applescript' }
Plug 'davidoc/taskpaper.vim', {'for': 'taskpaper'}
Plug 'leafgarland/typescript-vim', {'for': 'typescript'}
Plug 'majutsushi/tagbar'
" Plug 'xolox/vim-easytags'
Plug 'tpope/vim-surround'
Plug 'kien/ctrlp.vim'
Plug 'mhinz/vim-startify'
" Plug 'rip-rip/clang_complete', {'for': 'cpp'}
Plug 'justmao945/vim-clang', {'for': 'cpp'}
Plug 'ervandew/supertab'
Plug 'ryanoasis/vim-devicons'

if has('nvim')
  Plug 'numirias/semshi', {'for': 'python', 'do': ':UpdateRemotePlugins'}
  Plug 'arakashic/chromatica.nvim', {'for': 'cpp', 'do': ':UpdateRemotePlugins'}
  " Plug 'daeyun/vim-matlab', {'for': 'matlab'}
  " Plug 'rahlir/nvim-matlab', {'for': 'matlab'}
  Plug 'roxma/nvim-yarp'

  " Plug 'ncm2/ncm2'
  " Plug 'ncm2/ncm2-bufword'
  " Plug 'ncm2/ncm2-path'
  " Plug 'ncm2/ncm2-pyclang', {'for': 'cpp'}
else
  Plug 'octol/vim-cpp-enhanced-highlight', {'for': 'cpp'}
  " Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
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
set hidden
set completeopt+=longest
set fdm=marker
set modeline
set cursorline " Highlight the current line of cursor
set updatetime=1000
set exrc
set secure
set guioptions-=rL
set guifont=HackNerdFontComplete-Regular:h11

" Other:

let g:changelog_username = 'Tadeas Uhlir <tadeas.uhlir.19@dartmouth.edu>'

function! GetGruvColor(group)
  let guiColor = synIDattr(hlID(a:group), "fg", "gui") 
  let termColor = synIDattr(hlID(a:group), "fg", "cterm") 
  return [ guiColor, termColor ]
endfunction

" }}}
" Custom Mappings: {{{

nmap <M-CR> O<Esc>
nmap <CR> o<Esc>
nmap <silent> <leader>j <Plug>(ale_next)
nmap <silent> <leader>k <Plug>(ale_previous)
nmap <leader>p <C-w>}
nmap <leader>c <C-w>z
nmap ÷ :call CenterComment()<CR>
nmap <leader>s :set hlsearch!<CR>
nmap <leader>w :call RemLdWs()<CR>
nmap <leader>W :call RemLdWsGlobally()<CR>
nmap <leader>a :setlocal spell!<CR>
nnoremap ]a }kA
nnoremap [a {jI
map + :call BlockComment()<CR>
map - :call UnBlockComment()<CR>
nnoremap <leader>b :b #<CR>
nmap <leader>N :NERDTreeToggle<CR>
nmap <leader>t :Tagbar<CR>

" }}}

" ------------------------------Plugin Options--------------------------------
" Vimtex Options: {{{

let g:tex_flavor = 'latex'
let g:vimtex_view_method = 'skim'
let g:tex_comment_nospell = 1
let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_fold_manual = 1


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
  if exists('*GitGutterGetHunkSummary')
    let [ added, modified, removed ] = GitGutterGetHunkSummary()
    if added == 0
      return ''
    else
      return printf('%s %d', g:gitgutter_sign_added, added)
    endif
  endif
  return ''
endfunction

function! LightLineGitMod()
  if exists('*GitGutterGetHunkSummary')
    let [ added, modified, removed ] = GitGutterGetHunkSummary()
    if modified == 0
      return ''
    else
      return printf('%s %d', g:gitgutter_sign_modified, modified)
    endif
  endif
  return ''
endfunction

function! LightLineGitRemoved() 
  if exists('*GitGutterGetHunkSummary')
    let [ added, modified, removed ] = GitGutterGetHunkSummary()
    if removed == 0
      return ''
    else
      return printf('%s %d', g:gitgutter_sign_removed, removed)
    endif
  endif
  return ''
endfunction

function! LightLineGitBranch()
  if exists('*fugitive#head')
    let branch = fugitive#head()
    return branch !=# '' ? ' '.branch : ''
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
let g:SuperTabMappingBackward = '<M-Tab>'
let g:SuperTabClosePreviewOnPopupClose = 1

" }}}
" ALE Options: {{{

let g:ale_linters = {
      \   'python': ['pylint'],
      \   'cpp': ['gcc']
      \}
let g:ale_c_parse_compile_commands = '1'
let g:ale_cpp_clang_options = '-std=c++14 -I/usr/local/include/eigen3'
let g:ale_cpp_gcc_options = '-std=c++14 -I/usr/local/include/eigen3'

" }}}
" Clang_complete Options: {{{

let g:clang_library_path = '/usr/local/opt/llvm/lib'
let g:clang_user_options = '-std=c++14 -I/usr/local/include/eigen3'
let g:clang_complete_macros = 1
" let g:clang_debug = 1
let g:clang_close_preview = 1
let g:clang_jumpto_declaration_key = "æ"
let g:clang_snippets = 1
let g:clang_snippets_engine = 'ultisnips'
let g:clang_cpp_options = '-std=c++11 -stdlib=libc++'
let g:clang_dotfile = '.clang_complete'
let g:clang_cpp_completeopt = 'longest,menuone'
let g:clang_diagsopt = ''
" let g:clang_compilation_database = '..'

" }}}
" UltiSnips Options: {{{

let g:UltiSnipsSnippetDirectories = ['~/.vim/UltiSnips', 'UltiSnips']
let g:UltiSnipsEditSplit = 'tabdo'

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
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'vim', 'tagbar']

" }}}
" Indentline Options: {{{

let g:indentLine_char= ''
let g:indentLine_fileTypeExclude = ['startify', 'help']

" }}}
" NERDTree Options: {{{

let g:NERDTreeCaseSensitiveSort = 1

" }}}
" NERDTreeSyntasHl Options: {{{

let s:nerd_brown = "905532"
let s:nerd_aqua =  "3AFFDB"
let s:nerd_blue = "689FB6"
let s:nerd_darkBlue = "44788E"
let s:nerd_purple = "834F79"
let s:nerd_lightPurple = "834F79"
let s:nerd_red = "AE403F"
let s:nerd_beige = "F5C06F"
let s:nerd_yellow = "F09F17"
let s:nerd_orange = "D4843E"
let s:nerd_darkOrange = "F16529"
let s:nerd_pink = "CB6F6F"
let s:nerd_salmon = "EE6E73"
let s:nerd_green = "8FAA54"
let s:nerd_lightGreen = "31B53E"
let s:nerd_white = "FFFFFF"
let s:nerd_rspec_red = 'FE405F'
let s:nerd_git_orange = 'F54D27'

let g:NERDTreeExtensionHighlightColor = {} " this line is needed to avoid error
let g:NERDTreeExtensionHighlightColor['m'] = s:nerd_blue
let g:NERDTreeExtensionHighlightColor['hpp'] = s:nerd_green

" }}}
" WebDevIcons Options: {{{

let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {} " needed
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['m'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['mat'] = ''

if exists('g:loaded_webdevicons')
  call webdevicons#refresh()
endif


" }}}
" Startify Options: {{{

    let g:startify_bookmarks = [
            \ { 'v': '~/.vimrc' },
            \ { 'n': '~/.config/nvim/init.vim' },
            \ { 'z': '~/.zshrc' },
            \ { 't': '~/.config/kitty/kitty.conf' },
            \ ]

" }}}
" Tagbar Options: {{{

autocmd FileType cpp nested :call tagbar#autoopen(0)

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

function! RemLdWsGlobally()
  exe '%s/\s\+$//e'
  nohlsearch
endfunction

function! CenterComment()
  if &ft == 'cpp'
    let l:cmnt_raw = split(&commentstring, '%s')[0]
    let l:cmnt_better = substitute(l:cmnt_raw, ' ', '', '')
    let l:cmnt = substitute(l:cmnt_better, '\*', '/', '')
  else
    let l:cmnt_raw_other = split(&commentstring, '%s')[0]
    let l:cmnt = substitute(l:cmnt_raw_other, ' ', '', '')
  endif

  let l:del_str = '-'

  if &tw != 0
    let l:width = &tw
  else
    let l:width = 80
  endif

  let l:header = getline(".")
  let l:header_w = strlen(l:header)
  let l:before_w = (l:width - l:header_w) / 2
  let l:after_w = (l:width - l:header_w - l:before_w)
  let l:before = l:cmnt . ' ' . repeat(l:del_str, l:before_w-2)
  let l:after = repeat(l:del_str, l:after_w)

  call setline(".", l:before . l:header . l:after)
endfunc

" }}}
" Other Functions: {{{

function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" }}}
