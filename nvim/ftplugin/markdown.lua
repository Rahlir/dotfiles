-- Markdown filetype plugin for neovim
--
-- by Tadeas Uhlir <tadeas.uhlir@gmail.com>

-- ZK keymaps:
-- Keymaps to be used only when inside zk notebook
if require("zk.util").notebook_root(vim.fn.expand('%:p')) ~= nil then
  local bufopts = { silent=false, buffer=true }

  vim.keymap.set("n", "<CR>", function()
    local curcol = vim.api.nvim_win_get_cursor(0)[2]
    local starti, endi = string.find(vim.api.nvim_get_current_line(), "%[%[.+%]%]")
    if starti ~= nil then
      if starti <= curcol+1 and endi >= curcol+1 then
        vim.lsp.buf.definition()
        return
      end
    end
    local cursor_word = vim.fn.expand("<cword>")
    -- This matches 8 hex characters which is the start of UUID, so that
    -- should be task URI
    if cursor_word:match("^%x%x%x%x%x%x%x%x$") ~= nil then
      vim.cmd("!task " .. cursor_word)
      return
    end
    vim.cmd.normal('o')
  end, bufopts)
  vim.keymap.set("n", "<leader>zb", "<Cmd>ZkBacklinks<CR>", bufopts)
  vim.keymap.set("v", "<leader>zN", ":'<,'>ZkNewFromTitleSelection<CR>", bufopts)
end
