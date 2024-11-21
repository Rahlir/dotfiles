local module = {}

module.get_diagnostic_count = function(severity)
  local severity_nvim = {
    hint = vim.diagnostic.severity.HINT,
    info = vim.diagnostic.severity.INFO,
    warn = vim.diagnostic.severity.WARN,
    error = vim.diagnostic.severity.ERROR
  }

  if vim.diagnostic.is_disabled(0) then
    return 0
  else
    return vim.tbl_count(vim.diagnostic.get(
    0, { severity = severity_nvim[severity] }
    ))
  end
end

return module
