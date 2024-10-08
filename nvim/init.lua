-- ---------------------------General Vim Settings-----------------------------
-- Configurations: {{{
-- Source vim config files:
vim.opt.runtimepath:prepend{'~/.vim'}
vim.opt.runtimepath:append{'~/.vim/after'}
vim.cmd('source ~/.vimrc')

vim.opt.guicursor:append{'a:blinkwait700-blinkoff400-blinkon250'}
vim.opt.hlsearch = false
vim.opt.showcmd = false
vim.opt.updatetime = 300
-- Add fix that has already been added to vim (errorformat ignoring (g)make[\d]: *** mesages)
-- The vim fix was submitted here: https://groups.google.com/g/vim_dev/c/IUC2_PW2ZgI
vim.opt.errorformat = "%*[^\"]\"%f\"%*\\D%l: %m,\"%f\"%*\\D%l: %m,%-Gg%\\?make[%*\\d]: *** [%f:%l:%m,%-Gg%\\?make: *** [%f:%l:%m,%-G%f:%l: (Each undeclared identifier is reported only once,%-G%f:%l: for each function it appears in.),%-GIn file included from %f:%l:%c:,%-GIn file included from %f:%l:%c\\,,%-GIn file included from %f:%l:%c,%-GIn file included from %f:%l,%-G%*[ ]from %f:%l:%c,%-G%*[ ]from %f:%l:,%-G%*[ ]from %f:%l\\,,%-G%*[ ]from %f:%l,%f:%l:%c:%m,%f(%l):%m,%f:%l:%m,\"%f\"\\, line %l%*\\D%c%*[^ ] %m,%D%*\\a[%*\\d]: Entering directory %*[`']%f',%X%*\\a[%*\\d]: Leaving directory %*[`']%f',%D%*\\a: Entering directory %*[`']%f',%X%*\\a: Leaving directory %*[`']%f',%DMaking %*\\a in %f,%f|%l| %m"
vim.g.python3_host_prog = '$WORKON_HOME/neovim/bin/python'
-- }}}
-- Autocommands: {{{
local nvimrc_augroup = vim.api.nvim_create_augroup("nvimrc", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "cpp", "java", "typescriptreact", "javascriptreact", "python" },
  callback = function()
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo.foldlevel = 99
  end,
  group = nvimrc_augroup
})
-- Autocommand to use treesitter for indenting javascriptreact and typescriptreact files
-- with treesitter
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascriptreact", "typescriptreact" },
  command = "TSBufEnable indent",
  group = nvimrc_augroup
})
--- }}}
-- Diagnostics: {{{

-- Mappings:
local diagopts = { noremap=true, silent=true }
-- Diagnostic actions
vim.keymap.set('n', '<leader>dd', vim.diagnostic.open_float, diagopts)
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setqflist, diagopts)
-- Toggling diagnostics
vim.keymap.set('n', '<leader>sd', function()
  if vim.diagnostic.is_disabled(0) then
    vim.diagnostic.enable(0)
    vim.print("diagnostics were enabled...")
  else
    vim.diagnostic.disable(0)
    vim.print("diagnostics were disabled...")
  end
  vim.api.nvim_exec_autocmds("DiagnosticChanged", {})
end, diagopts)
vim.keymap.set('n', '<leader>sD', function()
  if vim.diagnostic.is_disabled(0) then
    vim.diagnostic.enable()
    vim.print("global diagnostics were enabled...")
  else
    vim.diagnostic.disable()
    vim.print("global diagnostics were disabled...")
  end
  vim.api.nvim_exec_autocmds("DiagnosticChanged", {})
end, diagopts)
-- Bracket movements
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, diagopts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, diagopts)

vim.diagnostic.config({
  virtual_text = false,
  signs = {
    priority = 99
  }
})

local signs = {Error = " ", Warn = " ", Hint = "󰌵 ", Info = " "}
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, {text = icon, texthl = hl, numhl = hl})
end
-- }}}

-- ------------------------------Plugin Options--------------------------------
-- Telescope: {{{
local themes = require('telescope.themes')
local builtin = require('telescope.builtin')

-- Mappings:
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fF', function()
  builtin.find_files({hidden=true})
end, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, {})
vim.keymap.set('n', '<leader>ft', builtin.git_status, {})
vim.keymap.set('n', '<leader>fr', builtin.resume, {})

require('telescope').setup{
  defaults = {
    layout_strategy = 'flex',

    layout_config = {
      flex = {
        flip_columns = 120
      }
    },

    preview = {
      timeout = 400
    },

    color_devicons = false,
    prompt_prefix = '󰭎 ',
    --- prompt_prefix = ' ',
    selection_caret = ' '
  }
}
-- }}}
-- Lightline: {{{
local lightline = vim.g.lightline

lightline.active.right = {
  { 'diag_errors', 'diag_warnings', 'diag_ok', 'diag_info', 'diag_hint' },
  { 'lineinfo', 'percent' },
  { 'fileformat', 'fileencoding', 'filetype' }
}
lightline.component_expand.diag_errors = 'rahlir#errors'
lightline.component_expand.diag_warnings = 'rahlir#warnings'
lightline.component_expand.diag_ok = 'rahlir#ok'
lightline.component_expand.diag_info = 'rahlir#info'
lightline.component_expand.diag_hint = 'rahlir#hints'

lightline.component_type.diag_errors = 'error'
lightline.component_type.diag_warnings = 'warning'
lightline.component_type.diag_ok = 'left'
lightline.component_type.diag_info = 'left'
lightline.component_type.diag_hint = 'left'

vim.g.lightline = lightline

-- Update lightline if diagnostics change
vim.api.nvim_create_autocmd('DiagnosticChanged', {
  callback = 'lightline#update',
  group = nvimrc_augroup
})
-- }}}
-- Treesitter: {{{
-- Mappings:
vim.keymap.set('n', '<leader>st', function()
  vim.cmd.TSToggle('highlight')
  vim.print("treesitter highlighting was toggled...")
end, { noremap=true, silent=true })
vim.keymap.set('n', '<leader>sT', function()
  vim.cmd.TSToggle('indent')
  vim.print("treesitter indent was toggled...")
end, { noremap=true, silent=true })

require('nvim-treesitter.configs').setup{
  ensure_installed = { "bash", "c", "cpp", "python", "vim", "make", "cmake",
                       "comment", "lua", "ledger", "latex", "markdown",
                       "markdown_inline", "javascript", "typescript", "tsx" },

  -- I think this could solve the error on updates when upgrading treesitter with plug
  sync_install = true,  -- only applied to `ensure_installed`
  highlight = {
    enable = true,  -- false will disable the whole extension

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = { "markdown", "vim" },
  },

  textobjects = {
    select = {
      enable = true,
      -- Automatically jump forward to textobj, similar to targets.vim 
      lookahead = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["ia"] = "@parameter.inner",
        ["aa"] = "@parameter.outer",
        ["ik"] = "@block.inner",
        ["ak"] = "@block.outer"
      },
    },

    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
        ["]k"] = "@block.outer",
        ["]a"] = "@parameter.inner"
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
        ["]K"] = "@block.outer",
        ["]A"] = "@parameter.inner"
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
        ["[k"] = "@block.outer",
        ["[a"] = "@parameter.inner"
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
        ["[K"] = "@block.outer",
        ["[A"] = "@parameter.inner"
      }
    },
  },
}
-- }}}
-- CMP: {{{
local cmp = require('cmp')

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local cmp_ultisnips_mappings = require('cmp_nvim_ultisnips.mappings')

-- See here: https://github.com/hrsh7th/nvim-cmp/issues/1251
local fixed_abort = function()
  cmp.abort()
  cmp.core:reset()
end

cmp.setup {
  snippet = {
    expand = function(args) vim.fn["UltiSnips#Anon"](args.body) end
  },

  mapping = {
    ["<Tab>"] = cmp.mapping(
    function(fallback)
      if has_words_before() then
        cmp_ultisnips_mappings.compose{"select_next_item", "expand"}(function()
          if cmp.visible() then
            if #cmp.get_entries() == 1 then
              cmp.confirm({ select = true })
            else
              cmp.select_next_item()
            end
          else
            cmp.complete()
            if #cmp.get_entries() == 1 then
              cmp.confirm({ select = true })
            end
          end
        end)
      else
        fallback()
      end
    end, {'i', 's'}),

    ["<S-Tab>"] = cmp.mapping(
    function(fallback)
      if has_words_before() and cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, {'i', 's'}),

    ['<C-y>'] = cmp.mapping(cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace, select = false}),
    {'i', 'c'}),

    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i'}),
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i'}),
    ['<C-u>'] = cmp.mapping(fixed_abort, {'i', 's'}),
  },

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'ultisnips' },
    { name = 'omni' }
  }),

  completion = {
    autocomplete = false
  },
  
  matching = {
    disallow_fuzzy_matching = true,
  }
}

local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- }}}
-- LspConfig: {{{
-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings:
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  local teleopts = {
    show_line=false, layout_config={ width=0.7, preview_width=0.45 }, initial_mode="normal"
  }

  -- Go to
  vim.keymap.set('n', 'gr', function()
    builtin.lsp_references(themes.get_cursor(teleopts))
  end, bufopts)

  vim.keymap.set('n', 'gd', function()
    builtin.lsp_definitions(themes.get_cursor(teleopts))
  end, bufopts)

  vim.keymap.set('n', '<leader>gi', function()
    builtin.lsp_implementations(themes.get_cursor(teleopts))
  end, bufopts)

  vim.keymap.set('n', '<leader>gd', vim.lsp.buf.declaration, bufopts)

  -- LSP Actions
  vim.keymap.set('n', '<leader>li', function()
    builtin.lsp_incoming_calls(themes.get_cursor(teleopts))
  end, bufopts)

  vim.keymap.set('n', '<leader>lo', function()
    builtin.lsp_outgoing_calls(themes.get_cursor(teleopts))
  end, bufopts)

  vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<leader>lc', vim.lsp.buf.code_action, bufopts)

  -- LSP Actions related to workspace
  vim.keymap.set('n', '<leader>lwa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>lwr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<leader>lwl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)

  -- Filetype specific LSP Actions
  if client.name == 'pyright' then
    vim.keymap.set('n', '<leader>li', vim.cmd.PyrightOrganizeImports, bufopts)
  end

  if client.name == 'tsserver' then
    vim.keymap.set('n', '<leader>li', vim.cmd.TsserverOrganizeImports, bufopts)
  end

  -- LSP Formatting
  vim.keymap.set({'n', 'v'}, '<leader>rl', function()
    vim.lsp.buf.format { async = true }
  end, bufopts)

  -- Telescope
  vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, bufopts)
  vim.keymap.set('n', '<leader>fS', builtin.lsp_dynamic_workspace_symbols, bufopts)

  -- Misc
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set({'n', 'i'}, '<C-s>', vim.lsp.buf.signature_help, bufopts)
end

require('lspconfig')['clangd'].setup{
  on_attach = on_attach,
  capabilities = capabilities
}

require('lspconfig')['pyright'].setup{
  on_attach = on_attach,
  capabilities = capabilities
}

local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = {vim.api.nvim_buf_get_name(0)},
    title = ""
  }
  vim.lsp.buf.execute_command(params)
end

require('lspconfig')['tsserver'].setup{
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    typescript = {
      format = {
        semicolons = 'remove'
      }
    }
  },
  commands = {
    TsserverOrganizeImports = {
      organize_imports,
      description = "Organize TS Imports"
    }
  }
}

require('lspconfig')['jdtls'].setup{
  on_attach = on_attach,
  capabilities = capabilities
}

require('lspconfig')['gopls'].setup{
  on_attach = on_attach,
  capabilities = capabilities
}
-- }}}
-- ZK: {{{
require("zk").setup({
  -- can be "telescope", "fzf" or "select"
  picker = "telescope",
  lsp = {
    config = {
      on_attach = on_attach
    }
  }
})

-- Mappings:
local opts = { noremap=true, silent=false }
vim.keymap.set("n", "<leader>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", opts)
vim.keymap.set("n", "<leader>zl", "<Cmd>ZkNotes<CR>", opts)
vim.keymap.set("n", "<leader>zt", "<Cmd>ZkTags<CR>", opts)
-- }}}
