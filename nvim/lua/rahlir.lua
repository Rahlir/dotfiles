local module = {}

module.get_diagnostic_count = function(severity)
  local severity_nvim = {
    hint = vim.diagnostic.severity.HINT,
    info = vim.diagnostic.severity.INFO,
    warn = vim.diagnostic.severity.WARN,
    error = vim.diagnostic.severity.ERROR
  }

  if vim.diagnostic.is_enabled({bufnr=0}) then
    return vim.tbl_count(vim.diagnostic.get(
    0, { severity = severity_nvim[severity] }
    ))
  else
    return 0
  end
end

local luasnip = require("luasnip")
local i = luasnip.insert_node
local sn = luasnip.snippet_node

module.get_visual = function(_, parent, _, user_args)
  if #parent.snippet.env.LS_SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else
    if user_args == nil then
      return sn(nil, i(1))
    else
      return sn(nil, i(1, user_args))
    end
  end
end

return module
