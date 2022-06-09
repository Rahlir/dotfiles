" --------------------------Using Settings for Vim----------------------------
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

" ----------------------NeoVim Specific Configuration-------------------------
set guicursor+=a:blinkwait700-blinkoff400-blinkon250
set noshowcmd
set nohlsearch
" I am not sure why this should be shorter in neovim but I read it somewhere.
" I think this has got to do something with preview windows and/or LSP
set updatetime=300

" ---------------------------Plugin Configuration-----------------------------
" Coc Options: {{{

" Use <tab> for trigger completion and navigate to the next complete item
inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()
imap <silent><expr> <S-Tab> 
      \ pumvisible() ? "\<C-p>" : "<Plug>delimitMateS-Tab"

nnoremap <silent> <leader>K :call CocActionAsync('doHover')<cr>
nnoremap <silent> <leader>g :call CocActionAsync('showSignatureHelp')<cr>
nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"

nmap <silent> gr <Plug>(coc-references)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> ge <Plug>(coc-declaration)

nmap <silent> <leader>rn <Plug>(coc-rename)
" }}}
if has("nvim-0.7.0")
" Treesitter Options: {{{
lua <<EOF
require('nvim-treesitter.configs').setup {
  ensure_installed = {"c", "cpp", "python", "vim", "make", "cmake", "comment", "lua", "markdown"}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  highlight = {
    enable = true,              -- false will disable the whole extension
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
EOF

lua <<EOF
require('nvim-treesitter.configs').setup {
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim 
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
      },
    },
  },
}
EOF
" }}}
" Telescope Options: {{{
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
lua <<EOF
require('telescope').setup{
  defaults = {
    layout_strategy = 'flex',
    layout_config = {flip_columns = 120}
  }
}
EOF
" }}}
endif

" --------------------------------Functions-----------------------------------
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction
