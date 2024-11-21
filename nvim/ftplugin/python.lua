-- Python filetype plugin
--
-- Simple filetype plguin for neovim that contains config specifically for
-- neovim. There is also a python filetype plugin for vim at
-- vim/ftplugin/python.vim. That one has setup for both vim and neovim.
--
-- by Tadeas Uhlir <tadeas.uhlir@gmail.com>

-- If isort plugin is installed, setup keybinds
--
-- This is in the neovim ftplugin because I am using that as a replaement for
-- LSP organize import. Hence I am using isort only in neovim even though it is
-- compatible with vim as well.
if vim.fn.exists(':Isort') and vim.fn.executable('isort') then
  vim.keymap.set(
    { "n", "v" }, "<leader>lI", "<Cmd>Isort<CR>",
    { silent = true, buffer = true, desc = "Organize imports" }
  )
end
