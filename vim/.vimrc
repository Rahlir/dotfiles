" Plug Section: {{{

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')
 
" Plugins for all systems and (neo)vims
Plug 'rahlir/gruvbox', {'branch': 'nvim_features'}
Plug 'sainnhe/everforest'
Plug 'tpope/vim-sensible'
Plug 'itchyny/lightline.vim'
Plug 'raimondi/delimitmate'
Plug 'tpope/vim-surround'
Plug 'christoomey/vim-tmux-navigator'
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'lervag/vimtex', {'for': 'tex'}
Plug 'ledger/vim-ledger', {'for': 'ledger'}
Plug 'mbbill/undotree'
Plug 'dhruvasagar/vim-table-mode', {'for': ['markdown', 'text', 'rst']}
Plug 'preservim/tagbar'
Plug 'kshenoy/vim-signature'
Plug 'psliwka/vim-smoothie'
Plug 'mattn/calendar-vim'
Plug 'vim-scripts/dbext.vim'

" Mac specific plugins. This check should work for any recent
" vim on macOS
if has('mac')
  Plug 'mityu/vim-applescript', {'for': 'applescript'}
endif

" Neovim specific plugins
if has('nvim')
  Plug 'stevearc/conform.nvim'
  Plug 'lukas-reineke/indent-blankline.nvim'
  Plug 'L3MON4D3/LuaSnip', {'tag': 'v2.*', 'do': 'make install_jsregexp'}
  Plug 'danymat/neogen'
  Plug 'neovim/nvim-lspconfig'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-treesitter/nvim-treesitter-textobjects'

  " This is not a neovim specific plugin, but I am using it as a
  " replacement of pyright's (LSP) organize import command. Hence I
  " moved it to neovim specific section.
  Plug 'brentyi/isort.vim', {'for': 'python'}

  Plug 'folke/which-key.nvim'
  Plug 'mickael-menu/zk-nvim'

  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'saadparwaiz1/cmp_luasnip'
  Plug 'hrsh7th/cmp-omni'
  Plug 'hrsh7th/nvim-cmp'

  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'

  " Unfortunately needs both devicons right now: vim-devicons is used by
  " lightline (and porting is not possible for fileformat) and startify,
  " while nvim-web-devicons is used by Telescope
  Plug 'ryanoasis/vim-devicons'
  Plug 'nvim-tree/nvim-web-devicons'

  Plug 'olimorris/codecompanion.nvim'
endif

call plug#end()
" }}}

" ---------------------------General Vim Settings-----------------------------
"  Setup Statedir: {{{

if !empty($XDG_STATE_HOME)
  let s:statedir = $XDG_STATE_HOME . '/vim'
else
  let s:statedir = $HOME . '/.local/state/vim'
endif
if !isdirectory(s:statedir)
  call mkdir(s:statedir)
endif

" }}}
" Different Vim Versions Compatibility: {{{

" Settings for regular vim
if !has('nvim')
  " Store viminfo and undo data in XDG_STATE_HOME/vim directory
  let &viminfofile=s:statedir . '/viminfo'
  let &undodir=s:statedir . '/undo'
  if !isdirectory(&undodir)
    call mkdir(&undodir)
  endif

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
  let g:everforest_background = 'soft'
else
  set background=dark
  let g:everforest_background = 'hard'
endif

" Gruvbox options
let g:gruvbox_italic = 1
let g:gruvbox_italicize_strings = 1
let g:gruvbox_contrast_dark = 'medium'
let g:gruvbox_contrast_light = 'soft'
let g:gruvbox_invert_selection = 0
let g:gruvbox_sign_column = 'bg0'
let g:gruvbox_markdown_ignore_errors = 1

" Everforest options
let g:everforest_enable_italic = 1

" Decide between everforest and gruvbox
if exists('$THEMENAME') && $THEMENAME == 'everforest'
  let g:current_colorscheme = 'everforest'
  colorscheme everforest
else
  if !exists('$THEMENAME')
    echomsg "$THEMENAME is not set, defaulting to gruvbox."
  endif
  let g:current_colorscheme = 'gruvbox'
  colorscheme gruvbox
endif

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
set signcolumn=yes  " signcolumn for gitgutter signs and diagnostics in number column
set linebreak  " visually break long lines at 'breakat'
set breakindent showbreak=+  " match indentation of the line and show '+' character on breakline
set laststatus=2  " always show status line
set title  " set window title, by default has the form 'filename [+=-] (path) - NVIM'
set mouse=a  " enable mouse for all modes
if has('vim_starting')  " do not override filetype specific settings
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
set updatetime=750  " after what delay should swap be written to and how long until gitgutter is updated
set exrc secure  " enable secure execution of .nvimrc and .vimrc in current directory
set completeopt+=longest
set wildmode=longest,full
set ignorecase smartcase  " ignore case in search unless it contains upper case
set confirm  " ask for a confirmation on :q with edits instead of failing
set cinoptions=(0,N-s,g0.5s,h0.5s,:0,  " C(++) indentation configuration
" Gui options:
set guioptions-=rL  " no scrollbars
set guifont=SFMonoNF-Regular:h13  " SFMono on macOS patched with nerdfonts
set undofile  " store undo data persistently
set clipboard^=unnamed,unnamedplus  " yanking and pasting using system clipboard
" how long to wait for next key in mappings. Default of 1000 is too long.
" Note that it affects which-key when which-key maps overlap with other plugins (such as y and ys)
" Commented out for now since it seems to have caused more harm than good
" set timeoutlen=500

" }}}
" Custom Mappings: {{{

" Configuring <space> as mapleader
nnoremap <space> <Nop>
let g:mapleader = ' '
let g:maplocalleader = ' '

" Add increment and decrement maps that work with modifier key instead of ctrl
nnoremap <M-a> <C-a>
nnoremap <M-x> <C-x>

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

function! s:RemoveTrailingSpace(global) abort
  if a:global
    let l:flags = 'ws'
    let l:trailingws = 0
    let l:nexthit = search('\s\+$', 'wn')
    while l:nexthit > 0
      let l:trailingws += 1
      let l:stripped = substitute(getline(l:nexthit), "\\s\\+$", "", "")
      call setline(l:nexthit, l:stripped)
      let l:nexthit = search('\s\+$', 'wn')
    endwhile
    if l:trailingws
      echo printf("Removed %d trailing space(s)", l:trailingws)
    else
      echo "No trailing space in the file"
    endif
  else
    if match(getline("."), "\\s\\+$") >= 0
      silent! s/\s\+$//
      echo "Trailing space removed"
    else
      echo "No trailing space on the current line"
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

function! s:QuickFixJump(movement) abort
  let l:qf_size = getqflist({'size': 1}).size
  if qf_size == 0
    echo "Note: nothing in the quickfix list"
    return
  endif
  let l:cur_qidx = getqflist({'idx': 0}).idx
  let l:new_qidx = cur_qidx + a:movement
  while new_qidx <= 0 || new_qidx > qf_size
    let l:new_qidx = new_qidx <= 0 ? new_qidx + qf_size : new_qidx - qf_size
  endwhile
  execute new_qidx . 'cc'
endfunction

function! s:LocListJump(movement) abort
  let l:qf_size = getloclist(0, {'size': 1}).size
  if qf_size == 0
    echo "Note: nothing in the quickfix list"
    return
  endif
  let l:cur_qidx = getloclist(0, {'idx': 0}).idx
  let l:new_qidx = cur_qidx + a:movement
  while new_qidx <= 0 || new_qidx > qf_size
    let l:new_qidx = new_qidx <= 0 ? new_qidx + qf_size : new_qidx - qf_size
  endwhile
  execute new_qidx . 'll'
endfunction

" }}}

" Commenting:
" Create section comments:
" Form --- Section ---
nnoremap <silent> <M-/> :<C-U>call <SID>SectionComment(0, v:count)<CR>
" Form ### Section ### with commented lines above and below
nnoremap <silent> <M-S-?> :<C-U>call <SID>SectionComment(1, v:count)<CR>
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
nnoremap <silent> <leader>rs :call <SID>RemoveTrailingSpace(0)<CR>
nnoremap <silent> <leader>rS :call <SID>RemoveTrailingSpace(1)<CR>

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
nnoremap <silent> [q <Cmd>call <SID>QuickFixJump(-1 * v:count1)<CR>
nnoremap <silent> ]q <Cmd>call <SID>QuickFixJump(v:count1)<CR>
" Location list items
nnoremap <silent> [l <Cmd>call <SID>LocListJump(-1 * v:count1)<CR>
nnoremap <silent> ]l <Cmd>call <SID>LocListJump(v:count1)<CR>
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
nnoremap <silent> <leader>ql :clast<CR>
nnoremap <silent> <leader>qL :packadd cfilter<CR>

" Location List:
nnoremap <silent> <leader>Ll :<C-U><C-R>=v:count ? 'll' . v:count : 'll'<CR><CR>
nnoremap <silent> <leader>Lo :lopen<CR>
nnoremap <silent> <leader>Lc :lclose<CR>
nnoremap <silent> <leader>Lw :lwindow<CR>
nnoremap <silent> <leader>Lf :lfirst<CR>
nnoremap <silent> <leader>LF :llast<CR>

" Buffer List:
nnoremap <silent> <leader>bb :buffer #<CR>
nnoremap <silent> <leader>bf :bfirst<CR>
nnoremap <silent> <leader>bF :blast<CR>

" File List:
nnoremap <silent> <leader>af :first<CR>
nnoremap <silent> <leader>aF :last<CR>

" Undotree Plugin:
if &runtimepath =~ 'undotree'
  nnoremap <silent> <leader>uu :UndotreeToggle<CR>
  nnoremap <silent> <leader>uO :UndotreeShow<CR>:UndotreeFocus<CR>
  nnoremap <silent> <leader>uo :UndotreeShow<CR>
  nnoremap <silent> <leader>uf :UndotreeFocus<CR>
  nnoremap <silent> <leader>uc :UndotreeHide<CR>
endif

" Tagbar Plugin:
if &runtimepath =~ 'tagbar'
  nnoremap <silent> <leader>tt :Tagbar<CR>
  nnoremap <silent> <leader>tf :TagbarOpen fj<CR>
  nnoremap <silent> <leader>tp :TagbarTogglePause<CR>
endif

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
" Spelling Setup: {{{

let s:spell_dir = $HOME . '/.vim/spell/'
if !filereadable(s:spell_dir . 'en.utf-8.add.spl') && filereadable(s:spell_dir . 'en.utf-8.add')
  silent! execute 'mkspell ' . s:spell_dir . 'en.utf-8.add'
  echom 'Spelling file generated at ' . s:spell_dir
endif

" }}}
" Custom Commands: {{{

function! s:SyntaxStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" Setup SytanxStack usercommand
command SyntaxStack call s:SyntaxStack()

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

if has('mac')
  let g:vimtex_view_method = 'skim'
else
  let g:vimtex_view_method = 'zathura'
endif
let g:vimtex_quickfix_open_on_warning = 0
let g:vimtex_fold_enabled = 1
let g:vimtex_fold_manual = 1
let g:vimtex_format_enabled = 1


" }}}
" GitGutter Options: {{{

let g:gitgutter_sign_added = "┃"
let g:gitgutter_sign_modified = "┃"
let g:gitgutter_sign_modified_removed   = '~'

" The following signs are used for lightline gitgutter status
let g:gitgutter_lightline_sign_added = "\Uf0419"
let g:gitgutter_lightline_sign_modified = "\Uf0377"
let g:gitgutter_lightline_sign_removed = "\Uf015a"

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
      \ 'colorscheme': g:current_colorscheme,
      \ 'separator': g:separator_def['separator'],
      \ 'subseparator': g:separator_def['subseparator'],
      \ 'active': {
      \ 'left': [['mode', 'paste'],
      \          ['readonly', 'filename', 'currentscope', 'gitbranch', 'tagbarsort'],
      \          ['gitsummary', 'tagbarflags']],
      \ 'right': [[],
      \           ['lineinfo', 'percent'],
      \           [ 'fileformat', 'fileencoding', 'filetype' ]]
      \ },
      \ 'component_function': {
      \       'gitbranch': 'LightLineGitBranch',
      \       'filetype': 'WebDevFiletype',
      \       'fileformat': 'WebDevFileformat',
      \       'mode': 'LightlineMode',
      \       'readonly': 'LightlineReadonly',
      \       'filename': 'LightlineFilename',
      \       'tagbarsort': 'LightlineTagbarsort',
      \       'fileencoding': 'LightlineFileencoding',
      \       'tagbarflags': 'LightlineTagbarflags',
      \       'currentscope': 'LightlineCurrentScope',
      \       'lineinfo': 'LightlineLineInfo',
      \       'percent': 'LightlinePercent'
      \ },
      \ 'component_expand': {
      \       'gitsummary': 'LightLineGitGutter',
      \   },
      \ 'component_type': {}
      \ }

" Lightline Component Functions:

function! LightLineGitGutter()
  if exists('*GitGutterGetHunkSummary')
    let [ added, modified, removed ] = GitGutterGetHunkSummary()
    if added == 0
      let added_s = ''
    else
      let added_s = printf('%s %d', g:gitgutter_lightline_sign_added, added)
    endif
    if modified == 0
      let modified_s = ''
    else
      let modified_s = printf('%s %d', g:gitgutter_lightline_sign_modified, modified)
    endif
    if removed == 0
      let removed_s = ''
    else
      let removed_s = printf('%s %d', g:gitgutter_lightline_sign_removed, removed)
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
        return winwidth(0) > 119 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
    else
        return &fileformat
    endif
endfunction

function! LightlineMode()
  let fname = expand('%:t')
  return fname =~# '^__Tagbar__' ? 'Tagbar'
        \ : winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! LightlineReadonly()
  return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction

function! LightlineModified()
  return &ft =~# 'help\|tagbar' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! LightlineFilename()
  let fname = expand('%:t')
  return fname =~# '^__Tagbar__' ? '' :
        \ fname ==# '__Calendar' ? strftime('%a %-d %B') :
        \ &filetype ==# 'startify' ? "󱓞 Let's start" :
        \ &filetype ==# 'codecompanion' ? CodeCompanionStatus() :
        \ (fname !=# '' ? fname : '[No Name]') .
        \ (LightlineModified() !=# '' ? ' ' . LightlineModified() : '')
endfunction

function! LightlineLineInfo()
  if winwidth(0) < 80
    return ''
  endif
  let lineinfo = printf('%3d:%-2d', line('.'), col('.'))
  return lineinfo
endfunction

function! CodeCompanionStatus()
  let icon = '  '
  let adapter = get(g:, 'codecompanion_adapter', "CodeCompanion")
  if g:codecompanion_request_started
    return icon . adapter . '  thinking 󱧤'
  elseif g:codecompanion_request_streaming
    return icon. adapter . '  talking 󱋊'
  endif

  return icon . adapter . "  ready "
endfunction

function! LightlinePercent()
  if winwidth(0) < 80
    return ''
  endif
  let percent = line('.') * 100 / line('$') . '%'
  return printf('%-4s', percent)
endfunction

function! LightLineGitBranch()
  if expand('%:t') !~# '^__Tagbar__' && exists('*FugitiveHead') && winwidth(0) > 119
    let branch = FugitiveHead()
    return branch !=# '' ? ' '.branch : ''
  endif
  return ''
endfunction

function! LightlineFileencoding()
  return winwidth(0) > 119 ? (&fenc !=# '' ? &fenc : &enc) : ''
endfunction

function! LightlineTagbarsort()
  if expand('%:t') =~# '^__Tagbar__'
    let fileinfo = tagbar#state#get_current_file(0)
    if !empty(fileinfo)
      let sorted = get(fileinfo.typeinfo, 'sort', g:tagbar_sort)
      return sorted ? 'Name' : 'Order'
    endif
  endif
  return ''
endfunction

function! LightlineTagbarflags()
  if expand('%:t') =~# '^__Tagbar__'
    let flags = []
    let flags += exists('w:autoclose') && w:autoclose ? ['c'] : []
    let flags += g:tagbar_autoclose ? ['C'] : []
    let flags += (g:tagbar_sort && g:tagbar_case_insensitive) ? ['i'] : []
    let flags += g:tagbar_hide_nonpublic ? ['v'] : []
    return join(flags, '')
  endif
  return ''
endfunction

function! LightlineCurrentScope()
  return exists('b:lightline_current_scope') ? b:lightline_current_scope : ""
endfunction

" Tagbar Status Configuration:

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, flags, ...) abort
  if a:current
    return lightline#statusline(0)
  else
    let flag_str = join(a:flags, '')
    let status_str = flag_str ==# '' ? 'Tagbar [' . a:sort . ']':
          \ 'Tagbar [' . a:sort . '] ' . flag_str
    let status_width = strwidth(status_str)
    let tagbar_width = winwidth(0)
    if tagbar_width > status_width + strwidth(a:fname)
      return status_str . '%=' . a:fname
    else
      return 'TB [' . a:sort . ']%= %<' . a:fname
endfunction

" Current Scope Update Implementation:

function! s:UpdateCurrentScope()
  let tag = tagbar#currenttag('%s', '', 'f', 'scoped-stl')
  if tag == ''
    let b:lightline_current_scope = ''
    call lightline#update()
  else
    let tagtype = tagbar#currenttagtype('%s', '')
    if tagtype == ''
      let icon = ''
    else
      let icon = get(g:tagbar_scopestrs, tagtype, "\uf420")
    endif

    let shortened = 0
    while len(tag) > 50
      let sro = get(tagbar#state#get_current_file(1).typeinfo, "sro", " ")
      let taglist = split(tag, escape(sro, '.'))
      let replacement = sro ==# '.' ? '>' : '...'
      let tag = join([replacement] + taglist[1+shortened:], sro)
      let shortened = 1
    endwhile

    " Customizations for different filetypes
    if &filetype ==# "markdown"
      let tag = substitute(tag, '""', ' # ', 'g')
    endif

    let b:lightline_current_scope = icon . ' ' . tag
  endif
  call lightline#update()
endfunction

" Autocmds Related To Lightline:

augroup vimrc_lightline
  autocmd!
  autocmd User GitGutter call lightline#update()
  " Tagbar autoloads for prototypes/* are slow. If you have to
  " initialize them on startup, you will get a significant slowdown of
  " startuptime. Hence, we only enable the lightline segment (and load
  " autoload functions) on the first CursorHold autocmd. Moreover,
  " tagbar#currenttag is an expensive function especially in large
  " files. Hence, we cache the current tag in a buffer variable and do
  " the update only on CursorHold events.
  autocmd CursorHold * call s:UpdateCurrentScope()
augroup END

" }}}
" DelimitMate Options: {{{

let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1
let g:delimitMate_expand_inside_quotes = 1
augroup vimrc_delimitmate
  autocmd!
  autocmd FileType python let b:delimitMate_smart_quotes = '\%(\%(\w\&[^fr]\)\|[^[:punct:][:space:]fr]\|\%(\\\\\)*\\\)\%#\|\%#\%(\w\|[^[:space:][:punct:]]\)'
  autocmd FileType tex let b:delimitMate_quotes = "\" ' ` $"
  autocmd FileType tex let b:delimitMate_smart_matchpairs = '^\%(\w\|\!\|£\|[^[:space:][:punct:]]\)'
  autocmd FileType markdown let b:delimitMate_nesting_quotes = ['`']
  autocmd FileType sql let b:delimitMate_quotes = "\" ' ` %"
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
let g:indentLine_fileTypeExclude = [
      \ 'startify', 'help', 'json',
      \ 'text', 'tex', 'markdown',
      \ 'man', 'dockerfile'
      \ ]

if g:current_colorscheme ==# 'gruvbox'
  let g:indentLine_color_term = GetGruvColor('GruvboxBg2')[1]
  let g:indentLine_color_gui = GetGruvColor('GruvboxBg2')[0]
endif

" }}}
" Devicons Options: {{{

" vim-devicons uses WebDevIcons as prefix for options
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols = {} " needed
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['m'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['mat'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['vue'] = ''
let g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['tex'] = ''

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
let g:ledger_date_format = '%Y-%m-%d'
let g:ledger_extra_options = '--pedantic'

" }}}
" Tagbar Options: {{{

let g:tagbar_scopestrs = {
      \ 'namespace': "\uea8b",
      \ 'class': "\Uf01bc",
      \ 'func': "\Uf0295",
      \ 'function': "\Uf0295",
      \ 'member': "\Uf0ae7",
      \ 'variable': "\Uf05c0",
      \ 'chapter': "\uf48a",
      \ 'section': "\Uf026c",
      \ 'subsection': "\Uf026d",
      \ 'subsubsection': "\Uf026e",
      \ 'l3subsection': "\Uf026f",
      \ 'l4subsection': "\Uf0270"
      \ }

" Keep sort as defined in the source file
let g:tagbar_sort = 0

" Default is <space> which conflicts with my <leader>
let g:tagbar_map_showproto = 'K'

let g:tagbar_file_size_limit = 100000

" Set color of protected tagbar icons to purple
highlight! link TagbarVisibilityProtected Purple
" Need to also setup autocmd to have orange marks after colorscheme change.
augroup vimrc_tagbar
  autocmd!
  autocmd ColorScheme * highlight! link TagbarVisibilityProtected Purple
augroup END

" }}}
" Tablemode Options: {{{

" Default is <leader>t which conflicts with my tagbbar mappings
let g:table_mode_map_prefix = '<leader>,'
let g:table_mode_tableize_d_map = '<leader><'

" }}} 
" DBExt Options: {{{

" Options:
let g:dbext_default_profile = ''
let g:dbext_default_passwd = ''
" My psqlrc contains helpful messages that can be silenced by setting
" quietstartup to 1
let g:dbext_default_PGSQL_cmd_options = '-v quietstartup=1'
let g:dbext_default_history_file = s:statedir . '/dbext_sql_history.txt'
let g:dbext_map_prefix = '<Leader>S'
let g:dbext_default_profile_dwh = 'type=ORA:user=NBA:passwd=STrE_20240626plu:srvname=dwhprdd-rac-scan.st.sk\:1525/EWH_USR_ALL'
let g:dbext_default_profile_dwhtmcz = 'type=ORA:user=NBA_TMCZ:passwd=PaS_UT20240528kls:srvname=dwhprdd-rac-scan.st.sk\:1525/EWH_USR_ALL'

" Functions:

" Connect DBExt to postgresql database using secrets stored in 1password.
" Arguments:
"   project: Project name. If set to 'autodetect', it will detect project name
"     from the current directory. Project name is the directory name whose
"     parent path is ~/Development/{tmobile,rahlir,ttc,other}. Default is
"     'autodetect'.
"   devenv: Development environment, one of 'dev', 'test', 'prod', or
"     'autodetect' dev, test, or prod. If set to 'autodetect', it will first
"     check the environmental variable DEVENV, if empty it will check if the
"     file contains dev, test, or prod, then it will fallback to prod. Default
"     is 'autodetect'.
function! s:DBExtConnectPSQL(...)
  let info_msg = ''

  let l:project = get(a:, 1, 'autodetect')

  if l:project ==# 'autodetect'
    let l:devpath_regex = '^' . $HOME . '/Development/\(tmobile\|rahlir\|ttc\|other\)/'
    let l:current_path = expand("%:p:h")

    if l:current_path !~# l:devpath_regex . '.\+'
      echo "ERROR: Not in recognizable project directory. Cannot autodetect project."
      return
    endif

    let l:project = split(
          \ substitute(l:current_path, l:devpath_regex, '', ''), '/'
          \ )[0]
    let info_msg .= "Autodetected project '" . l:project . "'. "
  endif

  let l:devenv = get(a:, 2, 'autodetect')

  if l:devenv ==# 'autodetect'
    if len($DEV_ENV) > 0
      let l:devenv = $DEV_ENV
      let info_msg .= "Autodetected devenv '" . l:devenv . "' from env var."
    elseif expand('%:t:r') =~# '^\(.*_\)\?\(dev\|test\|prod\)\(_.*\)\?$'
      let filename = expand('%:t:r')
      " Checked in the order of priority: prod > test > dev
      let l:devenv = filename =~# '^\(.*_\)\?\(prod\)\(_.*\)\?$' ? 'prod' : 
            \ filename =~# '^\(.*_\)\?\(test\)\(_.*\)\?$' ? 'test' : 'dev'
      let info_msg .= "Autodetected devenv '" . l:devenv . "' from filename."
    else
      let l:devenv = 'prod'
      let info_msg .= "Couldn't autodetect devenv, falling back to '" . l:devenv . "'."
    endif
  endif

  if len(info_msg)
    echom info_msg
  endif

  exec "DBSetOption type=PGSQL"
  let l:options = ["type=PGSQL"]

  let l:secret_item = "postgres_" . l:project . "_" . l:devenv
  let l:field_names = ["host", "port", "database", "user", "password"]
  let l:secrets = GetOPSecrets("Development", l:secret_item, l:field_names)
  let l:id = 0
  for field in l:field_names
    if field ==# "password"
      let l:pgpass_path = exists("g:dbext_default_PGSQL_pgpass") ? g:dbext_default_PGSQL_pgpass : "$HOME/.pgpass"
      call writefile(["*:*:*:*:" . l:secrets[l:id]], expand(l:pgpass_path), 's')
      call setfperm(expand(l:pgpass_path), "rw-------")
      let g:dbext_wrote_to_pgpass = 1
    else
      let l:dbext_field = field ==# "database" ? "dbname" : field
      exec "DBSetOption " . l:dbext_field . "=" . l:secrets[l:id]
      call add(l:options, l:dbext_field . "=" . l:secrets[l:id])
    endif
    let l:id += 1
  endfor
  execute 'redraw!'
  echo "DBExt options set: " . join(l:options, " ")
endfunction

function! s:ConnectPSQLComplete(lead, cmdline, cursorpos)
  let pre = strpart(a:cmdline, 0, a:cursorpos)
  let n_args = len(split(pre . 'end'))

  if n_args == 2
    " Complete project
    " NOTE: Unfortunately, these completions are static, hence I need to
    " update this list if I have more projects
    let completions = ['autodetect', 'nba', 'savedesk', 'volte', 'ocn', 'nakralovkach']
  elseif n_args == 3
    let completions = ['autodetect', 'prod', 'test', 'dev']
  else
    return ''
  endif
  return join(completions, "\n")
endfunction

" Remove .pgpass file that is used to store password to PostgreSQL database.
" Should be used as part of VimLeave autocommand in case DBExtConnectPSQL
" function wrote the file in order to cleanup.
function! s:RemovePGPass()
  let l:pgpass_path = exists("g:dbext_default_PGSQL_pgpass") ? g:dbext_default_PGSQL_pgpass : "$HOME/.pgpass"
  call delete(expand(l:pgpass_path))
endfunction

" Keymaps:
nnoremap <silent> <leader>Sr :DBResultsOpen<CR>
nnoremap <silent> <leader>SR :DBResultsClose<CR>

" Commands:
command -nargs=* -complete=custom,s:ConnectPSQLComplete DBExtConnectPSQL call s:DBExtConnectPSQL(<f-args>)

" Autocommands:
augroup dbextExtras
    autocmd!
    autocmd VimLeave * if exists('g:dbext_wrote_to_pgpass') | call s:RemovePGPass() | endif
augroup END

" }}}
" Calendar Options: {{{

let g:calendar_no_mappings = 1
let g:calendar_mark = 'left-fit'
let g:calendar_datetime = ''

" Functions:

" Function to be used for g:calendar_action which inserts link to a daily note
" for the selected date.
function g:ZkInsertDailyLink(day, month, year, week, dir)
  let l:linktext = printf("[[daily/%04d-%02d-%02d]]", a:year, a:month, a:day)
  call calendar#close()
  let l:cursorpos = getcurpos('.')
  let l:currentline = getline('.')
  let l:modifiedline = 
        \ strpart(l:currentline, 0, l:cursorpos[4] - 1)
        \ . l:linktext
        \ . strpart(l:currentline, l:cursorpos[4] - 1)
  call setline(l:cursorpos[1], l:modifiedline)
  startinsert
  call setpos('.', [
        \ 0,
        \ l:cursorpos[1],
        \ l:cursorpos[2]+len(l:linktext),
        \ l:cursorpos[3],
        \ l:cursorpos[4]+len(l:linktext)])
  if exists('g:old_calendar_action')
    let g:calendar_action = g:old_calendar_action
    unlet g:old_calendar_action
  else
    unlet g:calendar_action
  endif
endfunction

" Function to be used for g:calendar_sign which checks whether the given date
" has a daily note.
function! g:ZkDailySigns(day, month, year)
  let l:dailydir = "$ZK_NOTEBOOK_DIR/daily"
  let l:sfile = printf("%s/%04d-%02d-%02d.md", l:dailydir, a:year, a:month, a:day)
  return filereadable(expand(l:sfile))
endfunction

" Function to be used for g:calendar_action which opens a daily note for the
" selected date (used as default g:calendar_action when a zk note is opened).
function! g:ZkOpenDaily(day,month,year,week,dir)
  let l:dailydir = "$ZK_NOTEBOOK_DIR/daily"
  let l:dailyfile = printf("%s/%04d-%02d-%02d.md", l:dailydir, a:year, a:month, a:day)
  if !filereadable(expand(l:dailyfile))
    echo "ERROR: daily file for " . printf("%04d-%02d-%02d", a:year, a:month, a:day) . " does not exist!"
  else
    wincmd w
    execute "edit " . expand(l:dailyfile)
  endif
endfunction

" }}}
" Isort Options: {{{

let g:isort_vim_options = '--profile black'

" }}}
" Smoothie Options: {{{

let g:smoothie_update_interval = 16
let g:smoothie_speed_constant_factor = 15
let g:smoothie_speed_linear_factor = 15

" }}}
" Signature Options: {{{

let g:SignatureMarkTextHLDynamic = 1
let g:SignatureMarkerTextHLDynamic = 1

" Set color of marks to orange (instead of blue)
highlight! link SignatureMarkText OrangeSign
" Need to also setup autocmd to have orange marks after colorscheme change.
augroup vimrc_signature
  autocmd!
  autocmd ColorScheme * highlight! link SignatureMarkText OrangeSign
  autocmd User GitGutter call signature#sign#Refresh(1)
augroup END

"}}}
" --------------------------------Functions-----------------------------------
" Global Functions: {{{

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

function! SetEverforestBackground(bg)
  if a:bg == &background
    return
  endif

  if a:bg ==# 'dark'
    let g:everforest_background = 'hard'
  elseif a:bg ==# 'light'
    let g:everforest_background = 'soft'
  else
    return
  endif

  let &background=a:bg
  source ~/.vim/plugged/everforest/autoload/lightline/colorscheme/everforest.vim
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
  do ColorScheme
endfunction

if has('nvim')
  " Store output of a channel into dictonary in which the function is defined
  function! s:OPOnEvent(job_id, data, event) dict
    let var_ref = a:event
    let self[var_ref][-1] .= a:data[0]
    call extend(self[var_ref], a:data[1:])
  endfunction

  " Get secrets from 1password cli. Neovim specific function as it relies on
  " job-control of neovim. Signing into the op client is required only on the
  " first call to the function.
  " Arguments:
  "   vault: Vault name in which the item is stored.
  "   item: Item name
  "   fields: List of fields to return from the 1password item
  " Returns:
  "   List of values for the given item and fields.
  function! GetOPSecrets(vault, item, fields)
    if !exists('g:op_job_id')
      let g:op_job_output = {
            \ 'stdout': [''],
            \ 'stderr': [''],
            \ 'on_stdout': function('s:OPOnEvent'),
            \ 'on_stderr': function('s:OPOnEvent'),
            \ }
      let g:op_job_id = jobstart(split(&shell), g:op_job_output)
    else
      let g:op_job_output.stdout = ['']
      let g:op_job_output.stderr = ['']
    endif
    call chansend(g:op_job_id, "op item get --reveal --vault " . a:vault . " " . a:item . " --fields " . join(a:fields, ",") . "\n")
    while len(g:op_job_output.stdout[0]) == 0 && len(g:op_job_output.stderr[0]) == 0
      sleep 500m
    endwhile
    let result = split(g:op_job_output.stdout[0], ",")
    if len(g:op_job_output.stderr[0])
      echoerr "1password cli returned error: " . g:op_job_output.stderr[0]
    elseif len(result) != len(a:fields)
      echoerr "1password cli returned unexpected results: " . g:op_job_output.stdout[0]
    else
      return result
    endif
  endfunction
else

  " Get secrets from 1password cli. Unlike the more complex neovim function,
  " this function doesn't rely on job control and signing in is required on
  " every call.
  " Arguments:
  "   vault: Vault name in which the item is stored.
  "   item: Item name
  "   fields: List of fields to return from the 1password item
  " Returns:
  "   List of values for the given item and fields.
  function! GetOPSecrets(vault, item, fields)
    let l:secrets = systemlist("op item get --reveal --vault " . a:vault . " " . a:item . " --fields " . join(a:fields, ","))
    let l:result = split(l:secrets[0], ",")
    if len(l:result) != len(a:fields)
      echoerr "Failed to get secrets from 1password."
    endif
    return l:result
  endfunction
endif

" }}}
