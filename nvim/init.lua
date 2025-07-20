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

-- Keymaps:
local keymap_opts = { noremap=true, silent=true }
-- Restoring <S-Tab> of delimitmate: in neovim 0.11, <S-Tab> was mapped
-- to vim.snippet.expand by default.
vim.keymap.set('i', '<S-Tab>', '<Plug>delimitMateS-Tab', keymap_opts)
-- }}}
-- Autocommands: {{{
local nvimrc_augroup = vim.api.nvim_create_augroup("nvimrc", { clear = true })
-- Autocommand to use treesitter for folding where useful
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "cpp", "java", "typescriptreact", "javascriptreact", "python", "vue" },
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
  pattern = { "javascriptreact", "typescriptreact", "vue" },
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
  if not vim.diagnostic.is_enabled(0) then
    vim.diagnostic.enable(0)
    vim.print("diagnostics were enabled...")
  else
    vim.diagnostic.disable(0)
    vim.print("diagnostics were disabled...")
  end
  vim.api.nvim_exec_autocmds("DiagnosticChanged", {})
end, { desc = "Toggle diagnostics", unpack(diagopts) })
vim.keymap.set('n', '<leader>sD', function()
  if not vim.diagnostic.is_enabled(0) then
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
    priority = 99,
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = "󰌵 ",
      [vim.diagnostic.severity.INFO] = " ",
    }
  }
})

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
    { "<leader>C", group = "calendar", icon = "" },
    { "<leader>S", group = "dbext", icon = "" },
    { "<leader>c", group = "codecompanion", icon = "" },

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
    { "<leader>rs", desc = "Remove trailing spaces on current line" },
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

lightline.active.right[1] = {
  'diag_errors', 'diag_warnings', 'diag_ok', 'diag_info', 'diag_hint'
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
  vim.cmd.TSBufToggle('highlight')
  vim.print("treesitter highlighting was toggled...")
end, { noremap=true, silent=true, desc = "Toggle treesitter highlighting" })
vim.keymap.set('n', '<leader>sT', function()
  vim.cmd.TSBufToggle('indent')
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

    ['<space>'] = cmp.mapping(function(fallback)
      if cmp.visible() and cmp.get_active_entry() then
        cmp.confirm({ select = false })
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
  init_options = {
    plugins = {
      {
        name = "@vue/typescript-plugin",
        location = "/Users/uhlirt/.local/lib/node_modules/@vue/typescript-plugin",
        languages = { "javascript", "typescript", "vue" }
      }
    }
  },
  settings = {
    typescript = {
      format = {
        semicolons = 'remove'
      }
    }
  },
  filetypes = { "javascript", "typescript", "vue" },
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

local lsp_util = require('lspconfig.util')

local function get_typescript_server_path(root_dir)
  local global_ts = vim.env.HOMEBREW_PREFIX .. '/opt/typescript/libexec/lib/node_modules/typescript/lib'
  -- Alternative location if installed as root:
  -- local global_ts = '/usr/local/lib/node_modules/typescript/lib'
  local found_ts = ''
  local function check_dir(path)
    found_ts =  lsp_util.path.join(path, 'node_modules', 'typescript', 'lib')
    if lsp_util.path.exists(found_ts) then
      return path
    end
  end
  if lsp_util.search_ancestors(root_dir, check_dir) then
    return found_ts .. "LOCAL"
  else
    if not lsp_util.path.exists(global_ts) then
      error("No global or local typescript library found. Please install it.")
    end
    return global_ts
  end
end

require('lspconfig')['volar'].setup{
  on_new_config = function(new_config, new_root_dir)
    new_config.init_options.typescript.tsdk = get_typescript_server_path(new_root_dir)
  end,
  on_attach = on_attach,
  capabilities = capabilities,
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
-- conform: {{{
require("conform").setup({
  formatters_by_ft = {
    python = { "isort", "black", "docformatter" },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
    vue = { "prettierd", "prettier", stop_after_first = true }
  },
  default_format_opts = {
    lsp_format = "fallback"
  },
  notify_no_formatters = true,
  formatters = {
    docformatter = {
      inherit = true,
      append_args = { "--black" }
    }
  }
})
-- Setup conform formatexpr in filetypes where we have some conform formatters configured.
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "javascript", "typescript", "typescriptreact", "vue" },
  callback = function()
    vim.bo.formatexpr = "v:lua.require'conform'.formatexpr({'timeout_ms':2000})"
  end,
  group = nvimrc_augroup
})
-- Setup Conform command which runs conform on the entire buffer
vim.api.nvim_create_user_command("Conform", function()
  require("conform").format({ async = true })
end, {})
-- Setup Conform keybind which runs conform on the entire buffer
vim.keymap.set('n', '<leader>rc', function()
  require("conform").format({ async = true })
end, { noremap = true, silent = true, desc = "Format with conform" })
-- }}}
-- codecompanion: {{{
require("codecompanion").setup({
  adapters = {
    gemini = function()
      return require("codecompanion.adapters").extend("gemini", {
        schema = {
          model = {
            default = "gemini-2.5-pro"
          }
        }
      })
    end,
    gemini2 = function()
      return require("codecompanion.adapters").extend("gemini", {
        schema = {
          model = {
            default = "gemini-2.0-flash"
          }
        }
      })
    end
  },
  strategies = {
    chat = {
      adapter = "gemini",
      tools = {
        opts = {
          default_tools = {
            -- "grep_search",
            -- "file_search",
            -- "read_file"
          }
        }
      }
    },
    inline = {
      adapter = "gemini",
    },
    cmd = {
      adapter = "gemini",
    }
  },
  prompt_library = {
    ['Diff code review'] = {
      strategy = 'chat',
      description = 'Perform a code review',
      opts = {
        auto_submit = true,
        user_prompt = false,
        ignore_system_prompt = true,
      },
      prompts = {
        {
          role = 'system',
          content = [[
You are an experienced code review assistant. Your role is to help me
understand and analyze a merge request so I can provide thoughtful,
well-reasoned feedback to my colleague. Do not perform the code review yourself.
Instead, guide me through the process and help me identify what to focus on. You can
use @read_file @file_search and @grep_search to orient yourself in the code base.

Your Tasks:
1. Change Summary & Overview:
  - Provide a clear, high-level summary of what this merge request accomplishes
  - Identify the main files/modules affected and the nature of changes (new features, bug fixes, refactoring, etc.)
  - Highlight the scope and complexity of the changes

2. Areas Requiring Attention: Point out specific areas I should focus on during my review.
  - Critical Logic Changes: Functions/methods with complex business logic modifications
  - Security Considerations: Authentication, authorization, input validation, data handling
  - Performance Impact: Database queries, loops, memory usage, API calls
  - Error Handling: Exception handling, edge cases, failure scenarios
  - Dependencies: New libraries, version updates, external service integrations
  - Breaking Changes: API modifications, interface changes, backward compatibility

3. Review Focus Questions
For each significant change, help me think through:
  - What is this change trying to accomplish?
  - Are there any edge cases or scenarios that might not be handled?
  - Is the approach consistent with our existing codebase patterns?
  - Are there potential performance or security implications?
  - How might this affect other parts of the system?

4. Code Quality Checkpoints
Guide me to examine:
  - Readability: Is the code clear and well-documented?
  - Maintainability: Will future developers understand this easily?
  - Testing: Are there adequate tests for the changes?
  - Architecture: Does this fit well with our existing design patterns?
  - Standards: Does it follow our team's coding conventions?

5. Feedback Structuring
Help me organize my feedback into:
  - Must Fix: Critical issues that block the merge
  - Should Fix: Important improvements that enhance quality
  - Consider: Suggestions for potential improvements
  - Positive Notes: What was done well (important for team morale)

What I Need From You:
1. Analyze the diff/changes I provide and give me the overview above.
2. Ask clarifying questions if you need more context about our codebase or requirements
3. Suggest specific lines or sections I should pay extra attention to and why
4. When describing the changes of the merge request, show me the important code snippets
4. Help me formulate feedback comments based on my comments and our discussion
5. Help me formulate questions to ask the author if something is unclear
6. Remind me of best practices relevant to the specific changes being made

What You Should NOT Do:
- Don't write the code review comments for me unless prompted
- Don't make definitive judgments about whether code is "good" or "bad" unless prompted
- Don't provide solutions to issues you identify unless prompted

Remember: I want to be an engaged, thoughtful reviewer who provides valuable
feedback. Help me understand what I'm looking at and guide my analysis, but let
me draw the conclusions and write the feedback myself.
          ]]
        },
        {
          role = 'user',
          content = function()
            local target_branch = vim.fn.input('Target branch for merge base diff (default: develop): ', 'develop')
            local mr_diff = vim.fn.system('git diff --merge-base ' .. target_branch)
            return "This is the diff of the merge request:\n\n```\n" .. mr_diff .. "\n```\n\n"
          end,
        },
      },
    }
  }
})
vim.keymap.set({'n', 'v'}, '<leader>cc', '<cmd>CodeCompanionChat Toggle<cr>', { desc = "Toggle CodeCompanion chat", unpack(diagopts) })
vim.keymap.set({'n', 'v'}, '<leader>ca', '<cmd>CodeCompanionActions<cr>', { desc = "Open CodeCompanion action pallete", unpack(diagopts) })
vim.keymap.set({'v'}, '<leader>c=', '<cmd>CodeCompanionChat Add<cr>', { desc = "Add selected code to the chat buffer.", unpack(diagopts) })

local codecompanion_augroup = vim.api.nvim_create_augroup(
  "codecompanion",
  { clear = true }
)

vim.g.codecompanion_request_started = false
vim.g.codecompanion_request_streaming = false

vim.api.nvim_create_autocmd({ "User" }, {
  pattern = " CodeCompanionChatAdapter",
  group = codecompanion_augroup,
  callback = function(request)
    vim.print(request)
    if request.data.adapter == nil or vim.tbl_isempty(request.data) then
      return
    end
    vim.g.codecompanion_adapter = request.data.adapter.name
  end
})

vim.api.nvim_create_autocmd({ "User" }, {
  pattern = "CodeCompanionRequest*",
  group = codecompanion_augroup,
  callback = function(request)
    if request.match == "CodeCompanionRequestStarted" then
      vim.g.codecompanion_adapter = request.data.adapter.formatted_name
      vim.g.codecompanion_request_started = true
    elseif request.match == "CodeCompanionRequestStreaming" then
      vim.g.codecompanion_request_started = false
      vim.g.codecompanion_request_streaming = true
    else
      vim.g.codecompanion_request_started = false
      vim.g.codecompanion_request_streaming = false
    end
  end
})
-- }}}
