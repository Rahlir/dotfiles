# Config dotfiles for Vim & Bash

### Vim Config

Keymaps use `<space>` as `<leader>`. The systems for the keymaps is:

* `]` and `[` for movements such as:
    * `]d` or `[d`: next or previous diagnostic item
    * `]t` or `[t`: next or previous TODO comment
    * `]q` or `[q`: next or previous quickfix item
    * `]f` or `[f`: next or previous file in the file list
    * `]b` or `[b`: next or previous buffer in the buffer list
* `<leader><char>` where `<char>` represents mode / functionality
  for actions related to the mode / functionality
    * `<leader>q` for quickfix mappings:
        * `<leader>qq`: move to current quickfix item
        * `<leader>qo`: open quickfix window
        * `<leader>qw`: open quickfix window if there are quickfix items
    * `<leader>l` for location list mappings
    * `<leader>d` for diagnostics mappings
        * `<leader>dd`: open float for diagnostics under cursor
        * `<leader>dq`: add diagnostics under cursor to quickfix list
    * `<leader>f` for telescope mappings
        * `<leader>ff`: for `find_files` with Telescope
        * `<leader>fg`: for `live_grep` with Telescope
        * `<leader>fs`: for `git_status` with Telescope
        * `<leader>ft`: for `git_status` with Telescope
        * `<leader>fs`: for `lsp_symbols` with Telescope
    * `<leader>l` for lsp mappings
        * `<leader>lr`: to rename with lsp
        * `<leader>lc`: to run code action with lsp
    * `<leader>r` for formatting mappings
        * `<leader>rs`: remove white space on empty line
        * `<leader>rS`: remove white space on all empty lines in the file
        * `<leader>rl`: format with lsp
    * `<leader>s` for toggling various options

This setup was heavily inspired by [vim-unimpaired](https://github.com/tpope/vim-unimpaired)

### How to install
- Run bootstrap.sh
- Delete files of wrong operation system -> appendix "\_linux" or "\_mac"

### Sources
[Storing dotfiles](https://developer.atlassian.com/blog/2016/02/best-way-to-store-dotfiles-git-bare-repo/)

[Shell tools list](https://github.com/alebcay/awesome-shell)

[Shell tools list 2](https://github.com/awesome-lists/awesome-bash)

[Shell tools list 3](https://github.com/uhub/awesome-shell)

[Shell tools list 4](https://terminalsare.sexy)

[Shell tools list 5](https://nullrndtx.github.io/2016/02/21/Awesome-Shell.html)

[Colorschemes](http://chriskempson.com/projects/base16/)

[Vim plugins reference](https://medium.com/@huntie/10-essential-vim-plugins-for-2018-39957190b7a9)

### Requirements
- Git
- Tmux
- GNU ls
- Vim Plug
- Powerline
- Python + Pip
- powerline-gitstatus
