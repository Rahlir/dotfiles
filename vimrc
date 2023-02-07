" Plug Section: {{{

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')
 
Plug 'tpope/vim-sensible'
Plug 'lervag/vimtex', {'for': 'tex'}
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'christoomey/vim-tmux-navigator'
Plug 'raimondi/delimitmate'
Plug 'yggdroot/indentline'
Plug 'morhetz/gruvbox'
Plug 'Vimjas/vim-python-pep8-indent', {'for': 'python'}
Plug 'SirVer/ultisnips'
Plug 'dearrrfish/vim-applescript', {'for': 'applescript' }
Plug 'leafgarland/typescript-vim', {'for': 'typescript'}
Plug 'tpope/vim-surround'
Plug 'mhinz/vim-startify'

if has('nvim')
  Plug 'ryanoasis/vim-devicons'
  Plug 'nvim-tree/nvim-web-devicons'
  if has('nvim-0.7.0')
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/nvim-treesitter-textobjects', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/playground', {'do': ':TSUpdate'}

    Plug 'neovim/nvim-lspconfig'

    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'

    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'quangnguyen30192/cmp-nvim-ultisnips'
    Plug 'hrsh7th/nvim-cmp'
  endif
else
  Plug 'octol/vim-cpp-enhanced-highlight', {'for': 'cpp'}
  Plug 'ervandew/supertab'
  Plug 'kien/ctrlp.vim'
endif

call plug#end()

" }}}

" ---------------------------General Vim Settings-----------------------------
" Different Vim Versions Compatibility: {{{

if !has('gui_running') && !has('nvim')
  " set clipboard=exclude:.* " Turn off server for terminal vim
  let g:vimtex_compiler_latexmk = {'callback' : 0}
  if &term =~# '^tmux' || &term =~# 'alacritty'
  " Without this setting terminal vim doesn't display true colors with tmux
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
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
  autocmd ColorScheme gruvbox highlight! link DiagnosticError GruvboxRedBold
  autocmd ColorScheme gruvbox highlight! link DiagnosticWarn GruvboxYellowBold
  autocmd ColorScheme gruvbox highlight! link @namespace GruvboxFg3
  autocmd ColorScheme gruvbox highlight! link TelescopeBorder GruvboxFg4
  set background=dark
  let g:gruvbox_italic = 1
  let g:gruvbox_italicize_strings = 1
  let g:gruvbox_contrast_dark = 'medium'
  let g:gruvbox_contrast_light = 'soft'
  let g:gruvbox_invert_selection = 0
  colorscheme gruvbox
endif

" }}}
" Configurations: {{{

" Set Configurations:

set number lbr laststatus=2 title ruler mouse=a
set tabstop=8 softtabstop=4 shiftwidth=4 expandtab " Tab indentation
set noshowmode " Don't show -- INSERT --
set report=0 " Report any line yanked
set spelllang=en_us " Set spelling language
set splitright splitbelow " More natural splits
set hidden
set completeopt+=longest
set fdm=marker
set modeline
set cursorline " Highlight the current line of cursor
set updatetime=750
set exrc
set secure
set guioptions-=rL
set guifont=HackNerdFontComplete-Regular:h11
set wildmode=longest,full
set scl=yes
autocmd FileType nerdtree,tagbar,help setlocal scl=auto

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
nmap <leader>n :NERDTreeToggle<CR>
nmap <leader>N :NERDTreeFocus<CR>
nmap <leader>t :Tagbar<CR>
nmap <leader>T :TagbarOpen fj<CR>
nnoremap <silent> <leader><Space> :call FindTodo()<CR>

" }}}

" ------------------------------Plugin Options--------------------------------
" Vimtex Options: {{{

let g:tex_flavor = 'latex'
let g:vimtex_view_method = 'skim'
let g:tex_comment_nospell = 1
let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_fold_manual = 1
let g:vimtex_format_enabled = 1


" }}}
" GitGutter Options: {{{
let g:gitgutter_sign_added = "\uf918"
let g:gitgutter_sign_modified = "\uf876 "
let g:gitgutter_sign_removed = "\uf659 "
" }}}
" Lightline Options: {{{

let g:separator_def = {
      \ 'separator': {'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
  \ }
let g:separator_bubbles = {
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' },
  \ }

let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'separator': g:separator_bubbles['separator'],
      \ 'subseparator': g:separator_bubbles['subseparator'],
      \ 'active': {
      \ 'left': [['mode', 'paste'],
      \          ['readonly', 'filename', 'modified', 'gitbranch'],
      \          ['gitsummary']],
      \ 'right': [[],
      \           ['lineinfo', 'percent'], [ 'fileformat', 'fileencoding', 'filetype' ]]
      \ },
      \ 'component_function': {
      \       'gitbranch': 'LightLineGitBranch',
      \       'filetype': 'MyFiletype',
      \       'fileformat': 'MyFileformat',
      \       'cocstatus': 'coc#status',
      \       'currentfunction': 'CocCurrentFunction'
      \ },
      \ 'component_expand': {
      \       'gitsummary': 'LightLineGitGutter',
      \   },
      \ 'component_type': {}
\ }

function! LightLineGitGutter()
  if exists('*GitGutterGetHunkSummary')
    let [ added, modified, removed ] = GitGutterGetHunkSummary()
    if added == 0
      let added_s = ''
    else
      let added_s = printf('%s %d', g:gitgutter_sign_added, added)
    endif
    if modified == 0
      let modified_s = ''
    else
      let modified_s = printf('%s %d', g:gitgutter_sign_modified, modified)
    endif
    if removed == 0
      let removed_s = ''
    else
      let removed_s = printf('%s %d', g:gitgutter_sign_removed, removed)
    endif
  endif
  return [added_s, modified_s, removed_s]
endfunction

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

function! LightLineGitBranch()
  if exists('*FugitiveHead')
    let branch = FugitiveHead()
    return branch !=# '' ? ' '.branch : ''
  endif
  return ''
endfunction

autocmd User GitGutter call lightline#update()

" }}}
" DelimitMate Options: {{{

let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1
autocmd FileType python let b:delimitMate_smart_quotes = '\%(\%(\w\&[^fr]\)\|[^[:punct:][:space:]fr]\|\%(\\\\\)*\\\)\%#\|\%#\%(\w\|[^[:space:][:punct:]]\)'
au FileType tex let b:delimitMate_quotes = "\" ' ` $"
au FileType tex let b:delimitMate_smart_matchpairs = '^\%(\w\|\!\|£\|[^[:space:][:punct:]]\)'
au FileType markdown let b:delimitMate_nesting_quotes = ['`']

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

" UltiSnips Options: {{{

let g:UltiSnipsSnippetDirectories = ['~/.vim/UltiSnips']
let g:UltiSnipsEditSplit = 'tabdo'
let g:UltiSnipsExpandTrigger = '<M-tab>'

" }}}
" Indentline Options: {{{

let g:indentLine_char = ''
let g:indentLine_fileTypeExclude = ['startify', 'help', 'json', 'text', 'tex', 'markdown']

" }}}
" Devicons Options: {{{

" vim-devicons uses WebDevIcons as prefix for options
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
            \ { 'c': '~/.config/nvim/coc-settings.json' }
            \ ]

" }}}
" Tagbar Options: {{{

let g:tagbar_width = 35
let g:tagbar_foldlevel = 0

" }}}
" CtrlP Options: {{{

let g:ctrlp_extensions = ['tag']

" }}}

" --------------------------------Functions-----------------------------------
" Mappable Functions: {{{

function! BlockComment()
  let l:cmnt_raw = split(&commentstring, '%s')[0]
  let l:cmnt = substitute(l:cmnt_raw, '^\s*\(.\{-}\)\s*$', '\1', '')
  exe ':silent s/^\(\s*\)/\1' . l:cmnt . ' /'
  nohlsearch
endfunction

function! UnBlockComment()
  let l:cmnt_raw = split(&commentstring, '%s')[0]
  let l:cmnt = substitute(l:cmnt_raw, '^\s*\(.\{-}\)\s*$', '\1', '')
  exe ':silent s/^\(\s*\)' . l:cmnt .  ' /\1/e'
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
  if &ft == 'cpp' || &ft == 'c'
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

function! FindTodo()
  execute "normal /\\<TODO\\>\<CR>$"
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
