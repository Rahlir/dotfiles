" filetype.vim helper file
"
" Custom filetype.vim to enhance detection of files with my
" current setup. Notably this adds detection of files within
" dotfiles directory.
"
" by Tadeas Uhlir <tadeas.uhlir@gmail.com>

if exists("did_load_filetypes")
  finish
endif

if !empty($DOTDIR)
  augroup filetypedetect
    au! BufNewFile,BufRead $DOTDIR/git/config setf gitconfig
    au! BufNewFile,BufRead $DOTDIR/git/ignore setf gitignore

    au! BufNewFile,BufRead $DOTDIR/dircolors setf dircolors
  augroup END
endif

augroup filetypedetect
  au! BufNewFile,BufRead $XDG_STATE_HOME/vim/viminfo setf viminfo

  au! BufNewFile,BufRead */tridactyl/tridactylrc setf vim

  au! BufNewFile,BufRead */task/*/*.theme setf taskrc

  au! BufNewFile,BufRead $XDG_CONFIG_HOME/kube/config setf yaml
augroup END
