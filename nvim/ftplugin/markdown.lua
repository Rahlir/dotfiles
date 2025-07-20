-- Markdown filetype plugin for neovim
--
-- This plugin contains mostly setup for zk notes since that relies on ZK LSP.
-- Hence it needs to be in the neovim specific ftplugin.
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
  vim.keymap.set("n", "<leader>zL", "<Cmd>ZkLinks<CR>", { desc = "Links outgoing from this note", unpack(bufopts) })
  vim.keymap.set("n", "<leader>zb", "<Cmd>ZkBacklinks<CR>", { desc = "Backlinks to this note", unpack(bufopts) })
  vim.keymap.set("v", "<leader>zN", ":'<,'>ZkNewFromTitleSelection<CR>", { desc = "New note with title of selection", unpack(bufopts) })
  vim.keymap.set("i", "<M-d>", function()
    if vim.g.calendar_action ~= nil then
      vim.g.old_calendar_action = vim.g.calendar_action
    end
    vim.g.calendar_action = "ZkInsertDailyLink"
    vim.fn['calendar#show'](0)
  end, bufopts)
  vim.keymap.set("n", "<leader>Cc", "<Cmd>Calendar<CR>", { desc = "Daily note picker", unpack(bufopts) })

  -- When you run :Calendar in a zk note, you can use a calendar window to pick
  -- daily note to open.
  vim.g.calendar_sign = "ZkDailySigns"
  vim.g.calendar_action = "ZkOpenDaily"
end
