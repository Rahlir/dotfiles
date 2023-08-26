" Plug Section: {{{

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')
 
" Plugins for all systems and (neo)vims
Plug 'tpope/vim-sensible'
Plug 'itchyny/lightline.vim'
Plug 'morhetz/gruvbox'
Plug 'raimondi/delimitmate'
Plug 'yggdroot/indentline'
Plug 'tpope/vim-surround'
Plug 'christoomey/vim-tmux-navigator'
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'SirVer/ultisnips'
Plug 'lervag/vimtex', {'for': 'tex'}
Plug 'ledger/vim-ledger', {'for': 'ledger'}

" Mac specific plugins. This check should work for any recent
" vim on macOS
if has('mac')
  Plug 'mityu/vim-applescript', {'for': 'applescript' }
endif

" Neovim specific plugins
if has('nvim')
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/nvim-treesitter-textobjects', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/playground', {'do': ':TSUpdate'}

  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'quangnguyen30192/cmp-nvim-ultisnips'
  Plug 'hrsh7th/cmp-omni'
  Plug 'hrsh7th/nvim-cmp'

  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'

  Plug 'mickael-menu/zk-nvim'
  " Unfortunately needs both devicons right now: vim-devicons is used by
  " lightline (and porting is not possible for fileformat) and startify,
  " while nvim-web-devicons is used by Telescope
  Plug 'ryanoasis/vim-devicons'
  Plug 'nvim-tree/nvim-web-devicons'
  Plug 'windwp/nvim-ts-autotag'

" Vim specific plugins (in the future I think I should get rid of this
" and let vim configuration be as minimal as possible)
else
  Plug 'octol/vim-cpp-enhanced-highlight', {'for': 'cpp'}
  Plug 'ervandew/supertab'
  Plug 'kien/ctrlp.vim'
endif

call plug#end()
" }}}

" ---------------------------General Vim Settings-----------------------------
" Different Vim Versions Compatibility: {{{

" Settings for regular vim
if !has('nvim')
  " Store viminfo in XDG_STATE_HOME directory
  if !empty($XDG_STATE_HOME)
    let s:statedir = $XDG_STATE_HOME . '/vim'
  else
    let s:statedir = $HOME . '/.local/state/vim'
  endif
  if !isdirectory(s:statedir)
    call mkdir(s:statedir)
  endif
  let &viminfofile=s:statedir . '/viminfo'

  " Settings for regular terminal vim
  if !has('gui_running')
    let g:vimtex_compiler_latexmk = {'callback' : 0}
    if &term =~# '^tmux' || &term =~# 'alacritty'
    " Without this setting terminal vim doesn't display true colors with tmux
      let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
      let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    endif
  endif
endif

" }}}
" Syntax and Colors: {{{

" Gruvbox setup with dynamic dark/light switching
set termguicolors
syntax on

if has('nvim')
  " Extra colors for diagnostics, telescope, and treesitter
  augroup vimrc_colorscheme
    autocmd!
    autocmd ColorScheme gruvbox highlight! link DiagnosticError GruvboxRedBold
    autocmd ColorScheme gruvbox highlight! link DiagnosticWarn GruvboxYellowBold
    autocmd ColorScheme gruvbox highlight! link TelescopeBorder GruvboxFg4
    autocmd ColorScheme gruvbox highlight! link @namespace GruvboxFg3
    autocmd ColorScheme gruvbox highlight! link @variable GruvboxFg1
    autocmd ColorScheme gruvbox highlight! link @text.strike markdownStrike
    autocmd ColorScheme gruvbox highlight! link @text.strong markdownBold
    autocmd ColorScheme gruvbox highlight! link @text.emphasis markdownItalic
    autocmd ColorScheme gruvbox highlight! link @text.reference markdownLinkText
  augroup END
endif

" Dynamic dark/light switching
if exists('$THEMEBG') && $THEMEBG == 'light'
  set background=light
else
  set background=dark
endif

" Gruvbox options
let g:gruvbox_italic = 1
let g:gruvbox_italicize_strings = 1
let g:gruvbox_contrast_dark = 'medium'
let g:gruvbox_contrast_light = 'soft'
let g:gruvbox_invert_selection = 0
let g:gruvbox_sign_column = 'bg0'

colorscheme gruvbox

" This function needs to be here since it is used
" for Indentline options
function! GetGruvColor(group)
  let guiColor = synIDattr(hlID(a:group), "fg", "gui") 
  let termColor = synIDattr(hlID(a:group), "fg", "cterm") 
  return [ guiColor, termColor ]
endfunction

" }}}
" Configurations: {{{

" Setting options:
set number relativenumber  " show relative numbers and line number on current line
set signcolumn=number  " signcolumn for gitgutter signs and diagnostics in number column
set linebreak  " visually break long lines
set laststatus=2  " always show status line
set title  " set window title, by default has the form 'filename [+=-] (path) - NVIM'
set ruler  " show line and column number, might not be needed since lightline is used
set mouse=a  " enable mouse for all modes
set tabstop=8 softtabstop=4 shiftwidth=4 expandtab  " indentation with 4 spaces by default
set noshowmode  " don't show -- INSERT --
set report=0  " report any line yanked
set spelllang=en_us  " set spelling language
set splitright splitbelow  " more natural splits
set hidden  " keep buffer when switching to another file/buffer
set foldmethod=marker  " markers (three braces) create folds"
set modeline  " enable setting options with modeline
set cursorline  " highlight the current line of cursor
set updatetime=750  " after what delay should swap be written to
set exrc secure  " enable secure execution of .nvimrc and .vimrc in current directory
set completeopt+=longest
set wildmode=longest,full
set ignorecase smartcase  " ignore case in search unless it contains capital sign
" Gui options:
set guioptions-=rL  " no scrollbars
set guifont=SFMonoNF-Regular:h13  " SFMono on macOS patched with nerdfonts

" General autocommands:
augroup vimrc_general
  autocmd!
  autocmd FileType help setlocal scl=auto
augroup END

" Other options and variables:
let g:changelog_username = 'Tadeas Uhlir <tadeas.uhlir@gmail.com>'

" }}}
" Custom Mappings: {{{

nmap <M-CR> O<Esc>
nmap <CR> o<Esc>
" Open preview window with the tag under cursor
nmap <leader>p <C-w>}
" Close the preview window
nmap <leader>P <C-w>z
nmap <M-/> :call CenterComment()<CR>
nmap <leader>s :set hlsearch!<CR>
nmap <leader>w :call RemLdWs()<CR>
nmap <leader>W :call RemLdWsGlobally()<CR>
nmap <leader>a :setlocal spell!<CR>
" Enter insert mode at the end / beginning of a paragraph
nnoremap ]a }kA
nnoremap [a {jI
map + :call BlockComment()<CR>
map - :call UnBlockComment()<CR>
nnoremap <leader>b :b #<CR>
nnoremap <silent> <leader><Space> :call FindTodo()<CR>
" Quickfix mappings
nnoremap [q :cprev<CR>
nnoremap ]q :cnext<CR>
nnoremap <leader>cc :cc<CR>
nnoremap <leader>co :copen<CR>
nnoremap <leader>cl :cclose<CR>

" }}}

" ------------------------------Plugin Options--------------------------------
" Vimtex Options: {{{

let g:tex_flavor = 'latex'
let g:tex_comment_nospell = 1
let g:vimtex_view_method = 'skim'
let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_fold_manual = 1
let g:vimtex_format_enabled = 1


" }}}
" GitGutter Options: {{{
let g:gitgutter_sign_added = "\Uf0419"
let g:gitgutter_sign_modified = "\Uf0377"
let g:gitgutter_sign_removed = "\Uf015a"
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
      \ 'separator': g:separator_def['separator'],
      \ 'subseparator': g:separator_def['subseparator'],
      \ 'active': {
      \ 'left': [['mode', 'paste'],
      \          ['readonly', 'filename', 'modified', 'gitbranch'],
      \          ['gitsummary']],
      \ 'right': [[],
      \           ['lineinfo', 'percent'],
      \           [ 'fileformat', 'fileencoding', 'filetype' ]]
      \ },
      \ 'component_function': {
      \       'gitbranch': 'LightLineGitBranch',
      \       'filetype': 'WebDevFiletype',
      \       'fileformat': 'WebDevFileformat',
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

function! WebDevFiletype()
    if exists('*WebDevIconsGetFileTypeSymbol')
        return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
    else
        return &filetype
    endif
endfunction

function! WebDevFileformat()
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

augroup vimrc_lightline
  autocmd!
  autocmd User GitGutter call lightline#update()
augroup END

" }}}
" DelimitMate Options: {{{

let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1
augroup vimrc_delimitmate
  autocmd!
  autocmd FileType python let b:delimitMate_smart_quotes = '\%(\%(\w\&[^fr]\)\|[^[:punct:][:space:]fr]\|\%(\\\\\)*\\\)\%#\|\%#\%(\w\|[^[:space:][:punct:]]\)'
  autocmd FileType tex let b:delimitMate_quotes = "\" ' ` $"
  autocmd FileType tex let b:delimitMate_smart_matchpairs = '^\%(\w\|\!\|£\|[^[:space:][:punct:]]\)'
  autocmd FileType markdown let b:delimitMate_nesting_quotes = ['`']
augroup END

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

let g:indentLine_char = '┊'
let g:indentLine_fileTypeExclude = ['startify', 'help', 'json', 'text', 'tex', 'markdown', 'man']
let g:indentLine_color_term = GetGruvColor('GruvboxBg2')[1]
let g:indentLine_color_gui = GetGruvColor('GruvboxBg2')[0]

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
        \ { 'c': '~/.vimrc' },
        \ { 'n': '~/.config/nvim/init.lua' },
        \ { 'z': '~/.zshrc' },
        \ { 'a': '~/.config/alacritty/alacritty.yml' },
        \ ]
let g:startify_change_to_vcs_root = 1
let g:startify_files_number = 5

" }}}
" CtrlP Options: {{{

let g:ctrlp_extensions = ['tag']

" }}}
" Ledger Options: {{{

let g:ledger_bin = 'ledger'

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
  let l:before = l:cmnt . ' ' . repeat(l:del_str, l:before_w-5) . repeat(' ', 3)
  let l:after = repeat(' ', 3) . repeat(l:del_str, l:after_w-3)

  call setline(".", l:before . l:header . l:after)
endfunc

function! CenterCommentBig(...)
  let l:cmnt_raw_other = split(&commentstring, '%s')[0]
  let l:cmnt = substitute(l:cmnt_raw_other, ' ', '', '')

  let l:del_str = ' '

  if a:0 > 0
    let l:width = a:1
  elseif &tw != 0
    let l:width = &tw
  else
    let l:width = 80
  endif

  let l:header = getline(".")
  let l:header_w = strlen(l:header)
  let l:prepost_w = l:width / 16
  let l:before_w = (l:width - l:header_w - 2*l:prepost_w) / 2
  let l:after_w = l:width - l:header_w - l:before_w - 2*l:prepost_w
  let l:prepost = repeat(l:cmnt, l:prepost_w)
  let l:before =  repeat(l:del_str, l:before_w)
  let l:after = repeat(l:del_str, l:after_w)

  call setline(".", l:prepost . l:before . l:header . l:after . l:prepost)
endfunc

function! FindTodo()
  silent! execute "normal /\\<TODO\\>/;/$\<CR>"
endfunc

" }}}
" Other Functions: {{{

function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

function! SetGruvBackground(bg)
  if a:bg != 'dark' && a:bg != 'light'
    return
  endif
  if a:bg == &background
    return
  endif
  let &background=a:bg
  source ~/.vim/plugged/gruvbox/autoload/lightline/colorscheme/gruvbox.vim
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
  let g:indentLine_color_term = GetGruvColor('GruvboxBg2')[1]
  let g:indentLine_color_gui = GetGruvColor('GruvboxBg2')[0]
  do ColorScheme
endfunction

" }}}
