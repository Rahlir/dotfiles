function! rahlir#hints() abort
  let l:count = luaeval("require('rahlir').get_diagnostic_count('hint')")
  let l:sign = luaeval("vim.diagnostic.config().signs.text[vim.diagnostic.severity.HINT]")
  return l:count ? printf('%s%d', sign, count) : ''
endfunction

function! rahlir#infos() abort
  let l:count = luaeval("require('rahlir').get_diagnostic_count('info')")
  let l:sign = luaeval("vim.diagnostic.config().signs.text[vim.diagnostic.severity.INFO]")
  return l:count ? printf('%s%d', sign, count) : ''
endfunction

function! rahlir#warnings() abort
  let l:count = luaeval("require('rahlir').get_diagnostic_count('warn')")
  let l:sign = luaeval("vim.diagnostic.config().signs.text[vim.diagnostic.severity.WARN]")
  return l:count ? printf('%s%d', sign, count) : ''
endfunction

function! rahlir#errors() abort
  let l:count = luaeval("require('rahlir').get_diagnostic_count('error')")
  let l:sign = luaeval("vim.diagnostic.config().signs.text[vim.diagnostic.severity.ERROR]")
  return l:count ? printf('%s%d', sign, count) : ''
endfunction

function! rahlir#ok() abort
  let l:warnings = luaeval("require('rahlir').get_diagnostic_count('warn')")
  let l:errors = luaeval("require('rahlir').get_diagnostic_count('error')")
  if warnings == 0 && errors == 0 &&
        \ luaeval('vim.tbl_count(vim.lsp.get_clients({bufnr=' . bufnr() . '}))') != 0 &&
	\ luaeval('vim.diagnostic.is_enabled({bufnr=0})') == v:true
    return 'OK'
  endif
  return ''
endfunction
