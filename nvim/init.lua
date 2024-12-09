-- ---------------------------General Vim Settings-----------------------------
-- Configurations: {{{
--- Enable experimenta loader that speeds up startup
vim.loader.enable()

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
-- Autocommand to use treesitter for folding where useful
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
vim.keymap.set('n', '<leader>dd', vim.diagnostic.open_float, { desc = "Open current diagnostic", unpack(diagopts) })
vim.keymap.set('n', '<leader>dq', vim.diagnostic.setqflist, { desc = "Add all diagnostics to qflist", unpack(diagopts) })
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
end, { desc = "Toggle diagnostics", unpack(diagopts) })
vim.keymap.set('n', '<leader>sD', function()
  if vim.diagnostic.is_disabled(0) then
    vim.diagnostic.enable()
    vim.print("global diagnostics were enabled...")
  else
    vim.diagnostic.disable()
    vim.print("global diagnostics were disabled...")
  end
  vim.api.nvim_exec_autocmds("DiagnosticChanged", {})
end, { desc = "Toggle global diagnostics", unpack(diagopts) })

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
-- which-key: {{{
local wk = require("which-key")
wk.setup{
  preset = "helix",
  delay = function(ctx)
    return ctx.plugin and 0 or 500
  end,
  triggers = {
    { "<auto>", mode = "no" }
  },
  icons = { rules = {
    { pattern = "location", icon = "󱚐", color = "yellow" },
    { pattern = "fix", icon = "󱚊", color = "orange" },
    { pattern = "lsp", icon = " ", color = "orange" },
    { pattern = "netrw", icon = "", color = "blue" },
    { pattern = "note", icon = "󰠮", color = "purple" },
    { pattern = "workspace", icon = "󰙅", color = "orange" },
    { pattern = "tagbar", icon = "", color = "purple" },
    { pattern = "undotree", icon = "", color = "purple" },
    { pattern = "todo", icon = "", color = "cyan" },
    { pattern = "hunk", cat = "filetype", name = "git" },
    { pattern = "marker", icon = "󱘈", color = "orange" },
    { pattern = "mark", icon = "󰍎", color = "yellow" },
    { pattern = "vimtex", cat = "filetype", name = "tex", color = "green" }, 
  }},
  spec = {
    { "<leader>f", group = "telescope" },
    { "<leader>d", group = "diagnostics" },
    { "<leader>z", group = "notes"},
    { "<leader>n", group = "neogen", icon = "" },
    -- { "<leader>lI", desc = "Organize imports" },

    { "<leader>h", group = "gitgutter" },
    { "<leader>hp", desc = "Preview hunk" },
    { "<leader>hs", desc = "Stage hunk" },
    { "<leader>hu", desc = "Undo hunk" },

    { "<leader>s", group = "options", icon = "" },
    { "<leader>sh", desc = "Toggle hlsearch" },
    { "<leader>ss", desc = "Toggle spell" },
    { "<leader>si", desc = "Toggle ignorecase" },
    { "<leader>sc", desc = "Toggle colorcolumn" },

    { "<leader>r", group = "formatting" },
    { "<leader>rs", desc = "Remove trailing spaces in line" },
    { "<leader>rS", desc = "Remove trailing spaces globally" },

    { "<leader>i", group = "insert-shortcuts", icon = "" },
    { "<leader>ip", desc = "Insert mode at paragraph start" },
    { "<leader>iP", desc = "Insert mode at paragraph end" },

    { "<leader>e", group = "netrw" },
    { "<leader>ee", desc = "Open netrw" },
    { "<leader>el", desc = "Toggle netrw in left split" },
    { "<leader>eh", desc = "Open netrw in horizontal split" },

    { "<leader>q", group = "quickfix" },
    { "<leader>qq", desc = "Show count-th error" },
    { "<leader>qo", desc = "Open quickfix window" },
    { "<leader>qc", desc = "Close quickfix window" },
    { "<leader>qw", desc = "Toggle quickfix window (if errors)" },
    { "<leader>qf", desc = "Show first error" },
    { "<leader>ql", desc = "Show last error" },
    { "<leader>qL", desc = "Load cfilter plugin" },

    { "<leader>L", group = "locationlist" },
    { "<leader>Ll", desc = "Show count-th location" },
    { "<leader>Lo", desc = "Open location window" },
    { "<leader>Lc", desc = "Close location window" },
    { "<leader>Lw", desc = "Toggle location window (if locations)" },
    { "<leader>Lf", desc = "Show first location" },
    { "<leader>LF", desc = "Show last location" },

    { "<leader>b", group = "buffers" },
    { "<leader>bb", desc = "Switch to # buffer" },
    { "<leader>bf", desc = "Switch to first buffer" },
    { "<leader>bl", desc = "Switch to last buffer" },

    { "<leader>a", group = "files" },
    { "<leader>af", desc = "Switch to first file" },
    { "<leader>al", desc = "Switch to last file" },

    { "<leader>k", desc = "Move line up", icon = "" },
    { "<leader>j", desc = "Move line down", icon = "" },

    { "<leader>,", group = "tablemode" },

    { "<leader>u", group = "undotree" },
    { "<leader>uu", desc = "Toggle undotree" },
    { "<leader>uO", desc = "Open and focus undotree" },
    { "<leader>uo", desc = "Open undotree" },
    { "<leader>uf", desc = "Focus undotree" },
    { "<leader>uc", desc = "Close undotree" },

    { "<leader>t", group = "tagbar" },
    { "<leader>tt", desc = "Toggle tagbar" },
    { "<leader>tf", desc = "Open and focus tagbar" },
    { "<leader>tp", desc = "Toggle tagbar pause" },

    { "]f", desc = "Next file" },
    { "[f", desc = "Previous file" },
    { "]b", desc = "Next buffer" },
    { "[b", desc = "Previous buffer" },
    { "]l", desc = "Location list forward" },
    { "[l", desc = "Location list backward" },
    { "]q", desc = "Quickfix list forward" },
    { "[q", desc = "Quickfix list backward" },
    { "]t", desc = "Next todo" },
    { "[t", desc = "Previous todo" },
    { "]c", desc = "Next git hunk" },
    { "[c", desc = "Previous git hunk" },
    { "]`", desc = "Next mark" },
    { "[`", desc = "Previous mark" },
    { "]'", desc = "Next line with mark" },
    { "['", desc = "Previous line with mark" },
    { "]=", desc = "Next marker" },
    { "[=", desc = "Previous marker" },
    { "]-", desc = "Next marker of same type" },
    { "[-", desc = "Previous marker of same type" },
  },
}

vim.api.nvim_set_hl(0, "WhichKeyNormal", { link = "Normal", default = true })
vim.api.nvim_set_hl(0, "WhichKeyBorder", { link = "Grey", default = true })
vim.api.nvim_set_hl(0, "WhichKeyTitle", { fg = "fg", bg = "bg", bold = true, default = true })
-- }}}
-- Telescope: {{{
local themes = require('telescope.themes')
local builtin = require('telescope.builtin')

-- Mappings:
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Telescope files" })
vim.keymap.set('n', '<leader>fF', function()
  builtin.find_files({hidden=true})
end, { desc = "Telescope files including hidden" })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = "Telescope live grep" })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = "Telescope buffers" })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = "Telescope help tags" })
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = "Telescope diagnostics" })
vim.keymap.set('n', '<leader>ft', builtin.git_status, { desc = "Telescope git status" })
vim.keymap.set('n', '<leader>fr', builtin.resume, { desc = "Resume last telescope" })
vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = "Telescope keymaps" })

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
end, { noremap=true, silent=true, desc = "Toggle treesitter highlighting" })
vim.keymap.set('n', '<leader>sT', function()
  vim.cmd.TSToggle('indent')
  vim.print("treesitter indent was toggled...")
end, { noremap=true, silent=true, desc = "Toggle treesitter indent" })

require('nvim-treesitter.configs').setup{
  ensure_installed = { "bash", "c", "cpp", "python", "vim", "make", "cmake",
                       "comment", "lua", "ledger", "markdown",
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
        ["af"] = { query = "@function.outer", desc = "Function outer region" },
        ["if"] = { query = "@function.inner", desc = "Function inner region" },
        ["ac"] = { query = "@class.outer", desc = "Class outer region" },
        ["ic"] = { query = "@class.inner", desc = "Class inner region" },
        ["ia"] = { query = "@parameter.inner", desc = "Parameter inner region" },
        ["aa"] = { query = "@parameter.outer", desc = "Paramtere outer region" },
        ["ik"] = { query = "@block.inner", desc = "Block inner region" },
        ["ak"] = { query = "@block.outer", desc = "Block outer region" },
        ["ii"] = { query = "@conditional.inner", desc = "Conditional inner region" },
        ["ai"] = { query = "@conditional.outer", desc = "Conditional outer region" },
        ["il"] = { query = "@loop.inner", desc = "Loop inner region" },
        ["al"] = { query = "@loop.outer", desc = "Loop outer region" },
        ["i="] = { query = "@assignment.inner", desc = "Assignment inner region" },
        ["a="] = { query = "@assignment.outer", desc = "Assignment outer region" }
      },
    },

    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]m"] = { query = "@function.outer", desc = "Next function" },
        ["]]"] = { query = "@class.outer", desc = "Next class" },
        ["]k"] = { query = "@block.outer", desc = "Next block" },
        ["]a"] = { query = "@parameter.inner", desc = "Next parameter" },
      },
      goto_next_end = {
        ["]M"] = { query = "@function.outer", desc = "End of next function" },
        ["]["] = { query = "@class.outer", desc = "End of next class" },
        ["]K"] = { query = "@block.outer", desc = "End of next block" },
        ["]A"] = { query = "@parameter.inner", desc = "End of next parameter" },
      },
      goto_previous_start = {
        ["[m"] = { query = "@function.outer", desc = "Previous function" },
        ["[["] = { query = "@class.outer", desc = "Previous class" },
        ["[k"] = { query = "@block.outer", desc = "Previous block" },
        ["[a"] = { query = "@parameter.inner", desc = "Previous parameter" },
      },
      goto_previous_end = {
        ["[M"] = { query = "@function.outer", desc = "End of previous function" },
        ["[]"] = { query = "@class.outer", desc = "End of previous class" },
        ["[K"] = { query = "@block.outer", desc = "End of previous block" },
        ["[A"] = { query = "@parameter.inner", desc = "End of previous parameter" },
      }
    },
  },
}
-- }}}
-- Neogen: {{{

-- Remove @brief text from doxygen template
local doxygen = require("neogen.templates.doxygen")
doxygen[3] = { nil, " * $1", { no_results = true, type = { "func", "file", "class" } } }
doxygen[9] = { nil, " * $1", { type = { "func", "class", "type" } } }

local neogen = require("neogen")
neogen.setup{
  snippet_engine = "luasnip",

  languages = {
    python = {
      template = {
        annotation_convention = "reST"
      }
    },
  }
}

-- Keymaps:
vim.keymap.set("n", "<leader>nn", neogen.generate, { desc = "Generate for current obj", unpack(diagopts) })
vim.keymap.set("n", "<leader>nf", function()
  neogen.generate({ type = "func" })
end, { desc = "Generate for function", unpack(diagopts) })
vim.keymap.set("n", "<leader>nc", function()
  neogen.generate({ type = "class" })
end, { desc = "Generate for class", unpack(diagopts) })
vim.keymap.set("n", "<leader>nl", function()
  neogen.generate({ type = "file" })
end, { desc = "Generate for file", unpack(diagopts) })
vim.keymap.set("n", "<leader>nt", function()
  neogen.generate({ type = "type" })
end, { desc = "Generate for type", unpack(diagopts) })
-- }}}
-- LuaSnip: {{{
local luasnip = require('luasnip')
local types = require("luasnip.util.types")

luasnip.setup{
  enable_autosnippets = true,

  -- Update repeated tabstops on all text changes
  update_events = "TextChanged,TextChangedI",
  -- Check whether snippet has been deleted (don't want deleted snippets mess
  -- up <C-J>, etc.)
  delete_check_events = "TextChanged",

  -- Virtual mode uses <TAB> for snippets
  store_selection_keys = "<Tab>",

  -- Show "<- choice node" virtual text next to choice nodes
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { "<- choice node", { "Comment", "CursorLine"  } } },
      },
    },
  },
}

-- Keymaps:
vim.keymap.set({"i", "s"}, "<C-K>", function() luasnip.jump(-1) end, { silent = true })
vim.keymap.set({"i", "s"}, "<C-J>", function() luasnip.jump(1) end, { silent = true })
vim.keymap.set({"i", "s"}, "<C-E>", function()
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  end
end, { silent = true })

-- Load snippets at ~/.config/nvim/snippets
require("luasnip.loaders.from_lua").lazy_load({ paths = vim.env["XDG_CONFIG_HOME"] .. "/nvim/snippets" })
-- }}}
-- CMP: {{{
local cmp = require('cmp')

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

cmp.setup {
  snippet = {
    expand = function(args) luasnip.lsp_expand(args.body) end
  },

  mapping = {
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        if #cmp.get_entries() == 1 then
          cmp.confirm({ select = true })
        else
          cmp.select_next_item()
        end
      elseif has_words_before() then
        cmp.complete()
        if #cmp.get_entries() == 1 then
          cmp.confirm({ select = true })
        end
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

    ['<CR>'] = cmp.mapping(function(fallback)
      if cmp.visible() and cmp.get_active_entry() then
        cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
      else
        fallback()
      end
    end, {'i'}),

    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), {'i'}),
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), {'i'}),
    ['<C-u>'] = cmp.mapping(function(fallback) cmp.abort() end, {'i', 's'}),
  },

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
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

  wk.add({
    { "<leader>l", group = "lsp" },
    { "<leader>g", group = "lsp-goto-ext" },
    { "<leader>lw", group = "workspace" },
  })

  -- Mappings:
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  local teleopts = {
    show_line=false, layout_config={ width=0.7, preview_width=0.45 }, initial_mode="normal"
  }

  -- Go to
  vim.keymap.set('n', 'gr', function()
    builtin.lsp_references(themes.get_cursor(teleopts))
  end, { desc = "Go to references", unpack(bufopts) })

  vim.keymap.set('n', 'gd', function()
    builtin.lsp_definitions(themes.get_cursor(teleopts))
  end, { desc = "Go to definitions", unpack(bufopts) })

  vim.keymap.set('n', '<leader>gi', function()
    builtin.lsp_implementations(themes.get_cursor(teleopts))
  end, { desc = "Go to implementation", unpack(bufopts) })

  vim.keymap.set('n', '<leader>gd', vim.lsp.buf.declaration, { desc = "Go to declaration", unpack(bufopts) })

  -- LSP Actions
  vim.keymap.set('n', '<leader>li', function()
    builtin.lsp_incoming_calls(themes.get_cursor(teleopts))
  end, { desc = "LSP incoming calls", unpack(bufopts) })

  vim.keymap.set('n', '<leader>lo', function()
    builtin.lsp_outgoing_calls(themes.get_cursor(teleopts))
  end, { desc = "LSP outgoing calls", unpack(bufopts) })

  vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, { desc = "Rename variable", unpack(bufopts) })
  vim.keymap.set('n', '<leader>lc', vim.lsp.buf.code_action, { desc = "LSP code action", unpack(bufopts) })

  -- LSP Actions related to workspace
  vim.keymap.set('n', '<leader>lwa', vim.lsp.buf.add_workspace_folder, { desc = "Add workspace folder", unpack(bufopts) })
  vim.keymap.set('n', '<leader>lwr', vim.lsp.buf.remove_workspace_folder, { desc = "Remove workspace folder", unpack(bufopts) })
  vim.keymap.set('n', '<leader>lwl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)

  -- Filetype specific LSP Actions
  -- if client.name == 'pyright' then
  --   vim.keymap.set('n', '<leader>lI', vim.cmd.PyrightOrganizeImports, bufopts)
  -- end

  if client.name == 'ts_ls' then
    vim.keymap.set('n', '<leader>lI', vim.cmd.TsserverOrganizeImports, { desc = "Organize imports", unpack(bufopts) })
  end

  -- LSP Formatting
  vim.keymap.set({'n', 'v'}, '<leader>rl', function()
    vim.lsp.buf.format { async = true }
  end, { desc = "Format with LSP", unpack(bufopts) })

  -- Telescope
  vim.keymap.set(
  'n', '<leader>fs', builtin.lsp_document_symbols,
  { desc = "Telescope document symbols", unpack(bufopts) }
  )
  vim.keymap.set(
  'n', '<leader>fS', builtin.lsp_dynamic_workspace_symbols,
  { desc = "Telescope workspace symbols", unpack(bufopts) }
  )

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

require('lspconfig')['ts_ls'].setup{
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

require('lspconfig')['astro'].setup{
  on_attach = on_attach,
  capabilities = capabilities
}
-- }}}
-- ZK: {{{
require("zk").setup{
  -- can be "telescope", "fzf" or "select"
  picker = "telescope",
  lsp = {
    config = {
      on_attach = on_attach
    }
  }
}

-- Mappings:
local opts = { noremap=true, silent=false }
vim.keymap.set("n", "<leader>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", { desc = "New note", unpack(opts) })
vim.keymap.set("n", "<leader>zl", "<Cmd>ZkNotes<CR>", { desc = "List of notes", unpack(opts) })
vim.keymap.set("n", "<leader>zt", "<Cmd>ZkTags<CR>", { desc = "List of tags", unpack(opts) })

-- }}}
-- indent-blankline: {{{
local ibl = require("ibl")

ibl.setup{
  -- Using "LineNr" highlight group instead of Conceal because I am customizing
  -- Conceal highlight when editting tex buffers.
  indent = { char = "▏", highlight = "LineNr" },
  scope = { show_start = false, show_end = false },
}

-- Add to exclude filetypes (need to be update to merge lists)
ibl.update{
  exclude = { filetypes = { "startify", "markdown" } }
}
-- }}}
