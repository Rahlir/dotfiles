" Tex filetype plugin
"
" by Tadeas Uhlir <tadeas.uhlir@gmail.com>

" Vimtex uses conceals to prettify definitions of symbols. To really use this
" feature, we need to set conceallevel > 0.
setlocal conceallevel=2
" When using folding with vimtex, I want folds to be open by default.
set foldlevel=99

" Function to restore default everforest Conceal highlight group.
function! s:restore_conceal() abort
  let l:palette = everforest#get_palette(g:everforest_background, {})
  call everforest#highlight('Conceal', l:palette.grey0, l:palette.none)
endfunction

augroup ftplugin_tex_buffers
  autocmd! * <buffer>
  autocmd BufEnter <buffer> highlight! link Conceal Normal
  autocmd BufLeave <buffer> call s:restore_conceal()
  autocmd ColorScheme <buffer> highlight! link Conceal Normal
augroup END
