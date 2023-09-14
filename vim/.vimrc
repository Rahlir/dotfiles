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
Plug 'rahlir/gruvbox', { 'branch': 'nvim_features' }
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
" Setting Options: {{{

set number relativenumber  " show relative numbers and line number on current line
set signcolumn=number  " signcolumn for gitgutter signs and diagnostics in number column
set linebreak  " visually break long lines at 'breakat'
set breakindent showbreak=+  " match indentation of the line and show '+' character on breakline
set laststatus=2  " always show status line
set title  " set window title, by default has the form 'filename [+=-] (path) - NVIM'
set mouse=a  " enable mouse for all modes
if has('vim_starting')
  set tabstop=8 softtabstop=4 shiftwidth=4 expandtab  " indentation with 4 spaces by default
endif
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
set ignorecase smartcase  " ignore case in search unless it contains upper case
set confirm  " ask for a confirmation on :q with edits instead of failing
" Gui options:
set guioptions-=rL  " no scrollbars
set guifont=SFMonoNF-Regular:h13  " SFMono on macOS patched with nerdfonts

" }}}
" Custom Mappings: {{{

" Configuring <space> as mapleader
nnoremap <space> <Nop>
let g:mapleader = ' '

" Mapable Functions: {{{

function! s:BlockComment(mode) abort
  let l:cmnt_raw = empty(&commentstring) ? '# ' : split(&commentstring, '%s')[0]
  let l:cmnt = substitute(l:cmnt_raw, '^\s*\(.\{-}\)\s*$', '\1', '')
  if a:mode == 'add'
    let l:command = 's/^/' . l:cmnt . ' /'
  else
    let l:command = 's/^' . l:cmnt . ' //e'
  endif
  silent! execute l:command
  nohlsearch
endfunction

function! s:RemoveLeadingSpace(global) abort
  if a:global
    let l:flags = 'ws'
    let l:leadingws = 0
    let l:nexthit = search('\s\+$', 'wn')
    while l:nexthit > 0
      let l:leadingws += 1
      let l:stripped = substitute(getline(l:nexthit), "\\s\\+$", "", "")
      call setline(l:nexthit, l:stripped)
      let l:nexthit = search('\s\+$', 'wn')
    endwhile
    if l:leadingws
      echo printf("Removed %d leading spaces", l:leadingws)
    else
      echo "No leading space in the file"
    endif
  else
    if match(getline("."), "^\\s\\+$") == 0
      silent! s/\s\+$//
      echo "Leading space removed"
    else
      echo "No leading space on the current line"
    endif
  endif
endfunction

function! s:SectionComment(big, ...) abort
  if &ft == 'cpp' || &ft == 'c'
    let l:cmnt = '//'
  else
    let l:cmnt_raw = empty(&commentstring) ? '# ' : split(&commentstring, '%s')[0]
    let l:cmnt = substitute(l:cmnt_raw, '^\s*\(.\{-}\)\s*$', '\1', '')
  endif

  let l:del_str = a:big ? ' ' : '-'
  let l:width = get(a:, 1, &textwidth)
  if l:width == 0
    let l:width = 80
  endif

  let l:header = getline(".")
  let l:header_w = strlen(l:header)
  if a:big
    let l:prepost_w = l:width / 16
    let l:before_w = (l:width - l:header_w - 2*l:prepost_w) / 2
    let l:after_w = l:width - l:header_w - l:before_w - 2*l:prepost_w
    let l:prepost = repeat(l:cmnt, l:prepost_w / len(l:cmnt))
    let l:before =  repeat(l:del_str, l:before_w)
    let l:after = repeat(l:del_str, l:after_w)
    call setline(".", l:prepost . l:before . l:header . l:after . l:prepost)
    call append(line(".")-1, repeat(l:cmnt, l:width / len(l:cmnt)))
    call append(line("."), repeat(l:cmnt, l:width / len(l:cmnt)))
  else
    let l:before_w = (l:width - l:header_w) / 2
    let l:after_w = (l:width - l:header_w - l:before_w)
    let l:before = l:cmnt . ' ' . repeat(l:del_str, l:before_w-5) . repeat(' ', 3)
    let l:after = repeat(' ', 3) . repeat(l:del_str, l:after_w-3)
    call setline(".", l:before . l:header . l:after)
  endif
endfunc

function! s:FindTodo(reverse)
  if &ft == 'cpp' || &ft == 'c'
    let l:cmnt_reg = '\/\/\|\/\?\*'
  else
    let l:cmnt_raw = empty(&commentstring) ? '# ' : split(&commentstring, '%s')[0]
    let l:cmnt = substitute(l:cmnt_raw, '^\s*\(.\{-}\)\s*$', '\1', '')
    let l:cmnt_reg = escape(l:cmnt, '/*')
  endif
  let l:search_cmd = a:reverse ? '?' : '/'
  let l:pattern = '\(' . l:cmnt_reg . '\).*\<TODO\>'
  let l:flags = a:reverse ? 'bew' : 'ew'
  let l:res = search(l:pattern, l:flags)
  if l:res == 0
    echo "There is no TODO comment in the file"
  endif
endfunc

" Functions that are used in mappings
function! s:MoveLine(dir, count) abort
  if a:dir == 'up'
    silent! execute 'move--' . a:count
  elseif a:dir == 'down'
    silent! execute 'move+' . a:count
  endif
endfunction

function! s:ToggleOption(option) abort
  silent! execute 'setlocal ' . a:option . '!'
  if eval('&' . a:option)
    echo a:option . " was enabled..."
  else
    echo a:option . " was disabled..."
  endif
endfunction

function! s:ToggleColorColumn() abort
  if empty(&colorcolumn)
    set colorcolumn=+1
    echo "colorcolumn was drawn"
  else
    set colorcolumn=
    echo "colorcolumn was cleared"
  endif
endfunction

" }}}

" Commenting:
" Create section comments:
" Form --- Section ---
nnoremap <silent> <M-/> :<C-U>call <SID>SectionComment(0, v:count)<CR>
" Form ### Section ### with commented lines above and below
nnoremap <silent> <M-?> :<C-U>call <SID>SectionComment(1, v:count)<CR>
" Add / remove comments from a line or selected block
nnoremap <silent> + :call <SID>BlockComment('add')<CR>
nnoremap <silent> - :call <SID>BlockComment('remove')<CR>
vnoremap <silent> + :call <SID>BlockComment('add')<CR>
vnoremap <silent> - :call <SID>BlockComment('remove')<CR>

" Toggling Options:
nnoremap <silent> <leader>sh :call <SID>ToggleOption('hlsearch')<CR>
nnoremap <silent> <leader>ss :call <SID>ToggleOption('spell')<CR>
nnoremap <silent> <leader>si :call <SID>ToggleOption('ignorecase')<CR>
nnoremap <silent> <leader>sc :call <SID>ToggleColorColumn()<CR>

" Formatting Tweaks:
nnoremap <silent> <leader>rs :call <SID>RemoveLeadingSpace(0)<CR>
nnoremap <silent> <leader>rS :call <SID>RemoveLeadingSpace(1)<CR>

" Entering Insert Mode:
" Enter insert mode at the end / beginning of a paragraph
nnoremap <leader>ip }kA
nnoremap <leader>iP {jI

" Starting Netrw:
nnoremap <silent> <leader>ee :Explore<CR>
nnoremap <silent> <leader>el :Lexplore<CR>
nnoremap <silent> <leader>eh :Hexplore<CR>

" Bracket Movements:
" Todos
nnoremap <silent> ]t :call <SID>FindTodo(0)<CR>
nnoremap <silent> [t :call <SID>FindTodo(1)<CR>
" Quickfix items
nnoremap <silent> [q :cprev<CR>
nnoremap <silent> ]q :cnext<CR>
" Location list items
nnoremap <silent> [l :lprev<CR>
nnoremap <silent> ]l :lnext<CR>
" Buffers
nnoremap <silent> [b :bprev<CR>
nnoremap <silent> ]b :bnext<CR>
" Files
nnoremap <silent> [f :prev<CR>
nnoremap <silent> ]f :next<CR>

" Quickfix:
nnoremap <silent> <leader>qq :<C-U><C-R>=v:count ? 'cc' . v:count : 'cc'<CR><CR>
nnoremap <silent> <leader>qo :copen<CR>
nnoremap <silent> <leader>qc :cclose<CR>
nnoremap <silent> <leader>qw :cwindow<CR>
nnoremap <silent> <leader>qf :cfirst<CR>
nnoremap <silent> <leader>qF :clast<CR>

" Location List:
nnoremap <silent> <leader>ll :<C-U><C-R>=v:count ? 'll' . v:count : 'll'<CR><CR>
nnoremap <silent> <leader>lo :lopen<CR>
nnoremap <silent> <leader>lc :lclose<CR>
nnoremap <silent> <leader>lw :lwindow<CR>
nnoremap <silent> <leader>lf :lfirst<CR>
nnoremap <silent> <leader>lF :llast<CR>

" Buffer List:
nnoremap <silent> <leader>bb :buffer #<CR>
nnoremap <silent> <leader>bf :bfirst<CR>
nnoremap <silent> <leader>bF :blast<CR>

" File List:
nnoremap <silent> <leader>af :first<CR>
nnoremap <silent> <leader>aF :last<CR>

" Misc:
" Move lines up / down
nnoremap <silent> <leader>k :<C-U>call <SID>MoveLine('up', v:count1)<CR>
nnoremap <silent> <leader>j :<C-U>call <SID>MoveLine('down', v:count1)<CR>
" Insert empty line above / below
nnoremap <M-CR> O<Esc>
nnoremap <CR> o<Esc>

" }}}
" Filetype Plugin Configuration: {{{

" Python
let g:python_indent = {
      \ 'open_paren': 'shiftwidth()',
      \ 'continue': 'shiftwidth()',
      \ 'closed_paren_align_last_line': v:false
  \ }

" Tex
let g:tex_flavor = 'latex'
let g:tex_comment_nospell = 1

" }}}

" ------------------------------Plugin Options--------------------------------
" Netrw Options: {{{

augroup vimrc_netrw
  autocmd!
  autocmd filetype netrw nmap <buffer> <silent> <c-e> <Plug>NetrwRefresh
  autocmd filetype netrw noremap <silent> <c-l> :<C-U>TmuxNavigateRight<CR>
augroup END
nmap <silent> <c-e> <Plug>NetrwRefresh

" }}}
" Vimtex Options: {{{

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
" Ledger Options: {{{

let g:ledger_bin = 'ledger'

" }}}

" --------------------------------Functions-----------------------------------
" Global Functions: {{{

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
