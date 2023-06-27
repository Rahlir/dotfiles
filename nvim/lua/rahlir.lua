local module = {}

module.get_diagnostic_count = function(severity)
    local severity_nvim = {
        hint = vim.diagnostic.severity.HINT,
        info = vim.diagnostic.severity.INFO,
        warn = vim.diagnostic.severity.WARN,
        error = vim.diagnostic.severity.ERROR
    }

    return vim.tbl_count(vim.diagnostic.get(
        vim.api.nvim_get_current_buf(), {severity = severity_nvim[severity]}
    ))
end

return module
