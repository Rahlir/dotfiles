" Markdown filetype plugin
"
" by Tadeas Uhlir <tadeas.uhlir@gmail.com>

" Conceal links, typesetting characters, etc.
setlocal conceallevel=2
" Syntax highlighting in code blocks (nvim uses treesitter, so not needed)
if !has('nvim')
  let g:markdown_fenced_languages = [
        \ 'vim',
        \ 'python',
        \ 'zsh',
        \ 'bash',
        \ 'cpp',
        \ 'c']
endif
" Turn on spelling in markdown files
setlocal spell
