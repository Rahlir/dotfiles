function! rahlir#hints() abort
  let l:count = luaeval("require('rahlir').get_diagnostic_count('hint')")
  let l:sign = sign_getdefined('DiagnosticSignHint')[0]['text']
  return l:count ? printf('%s%d', sign, count) : ''
endfunction

function! rahlir#infos() abort
  let l:count = luaeval("require('rahlir').get_diagnostic_count('info')")
  let l:sign = sign_getdefined('DiagnosticSignInfo')[0]['text']
  return l:count ? printf('%s%d', sign, count) : ''
endfunction

function! rahlir#warnings() abort
  let l:count = luaeval("require('rahlir').get_diagnostic_count('warn')")
  let l:sign = sign_getdefined('DiagnosticSignWarn')[0]['text']
  return l:count ? printf('%s%d', sign, count) : ''
endfunction

function! rahlir#errors() abort
  let l:count = luaeval("require('rahlir').get_diagnostic_count('error')")
  let l:sign = sign_getdefined('DiagnosticSignError')[0]['text']
  return l:count ? printf('%s%d', sign, count) : ''
endfunction

function! rahlir#ok() abort
  let l:warnings = luaeval("require('rahlir').get_diagnostic_count('warn')")
  let l:errors = luaeval("require('rahlir').get_diagnostic_count('error')")
  if warnings == 0 && errors == 0 &&
	\ luaeval('vim.tbl_count(vim.lsp.buf_get_clients(' . bufnr() . '))') != 0 &&
	\ luaeval('vim.diagnostic.is_disabled(0)') != v:true
    return 'OK'
  endif
  return ''
endfunction
