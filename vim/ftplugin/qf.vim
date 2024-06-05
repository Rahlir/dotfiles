nnoremap <buffer> <silent> <CR> :.cc<CR>
nnoremap <buffer> H :colder<CR>
nnoremap <buffer> L :cnewer<CR>
nnoremap <buffer> <silent> K k:.cc<CR>zz<C-w>w
nnoremap <buffer> <silent> J j:.cc<CR>zz<C-w>w

setlocal errorformat+=%f\|%l\ col\ %c\|%m
nnoremap <buffer> <silent> M :set modifiable!<CR>
nnoremap <buffer> <silent> R :cgetbuffer<CR>:set nomodified<CR>
