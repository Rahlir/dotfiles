-- TeX filetype plugin
--
-- Simple filetype plugin for latex files. This is for configs exclusive to
-- neovim. The vim / neovim configs are in vim/ftplugin/tex.vim.
--
-- by Tadeas Uhlir <tadeas.uhlir@gmail.com>

local wk = require("which-key")

local latex_icon = { cat = "filetype", name = "tex", color = "green" }

wk.add({
  { "<leader>l", group = "vimtex" },
  { "<leader>li", buffer = true, desc = "Information", icon = latex_icon },
  { "<leader>lI", buffer = true, desc = "Full information", icon = latex_icon },
  { "<leader>lt", buffer = true, desc = "Table of contents", icon = latex_icon },
  { "<leader>lT", buffer = true, desc = "Toggle table of contents", icon = latex_icon },
  { "<leader>lq", buffer = true, desc = "Log", icon = latex_icon },
  { "<leader>lv", buffer = true, desc = "View current pos in PDF", icon = latex_icon },
  { "<leader>lr", buffer = true, desc = "MuPDF reverse search", icon = latex_icon },
  { "<leader>ll", buffer = true, desc = "Compile", icon = latex_icon },
  { "<leader>lL", buffer = true, desc = "Compile selected", icon = latex_icon },
  { "<leader>lk", buffer = true, desc = "Stop compilation", icon = latex_icon },
  { "<leader>lK", buffer = true, desc = "Stop compilation for all projects", icon = latex_icon },
  { "<leader>le", buffer = true, desc = "Open QF with errors", icon = latex_icon },
  { "<leader>lo", buffer = true, desc = "Open output", icon = latex_icon },
  { "<leader>lg", buffer = true, desc = "Compilation status", icon = latex_icon },
  { "<leader>lG", buffer = true, desc = "Compilation status for all projects", icon = latex_icon },
  { "<leader>lc", buffer = true, desc = "Clean compile files", icon = latex_icon },
  { "<leader>lC", buffer = true, desc = "Clean compile and output files", icon = latex_icon },
  { "<leader>lm", buffer = true, desc = "Show insert mappings", icon = latex_icon },
  { "<leader>lx", buffer = true, desc = "Reload", icon = latex_icon },
  { "<leader>lX", buffer = true, desc = "Reload state for current buffer", icon = latex_icon },
  { "<leader>ls", buffer = true, desc = "Toggle main / current file", icon = latex_icon },
  { "<leader>la", buffer = true, desc = "Context menu", icon = latex_icon },
})
