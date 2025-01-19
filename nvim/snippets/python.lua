local get_visual = require("rahlir").get_visual

local function gen_self_choices()
  local parser = vim.treesitter.get_parser()
  local tree = parser:parse()[1]

  local current_line_no = vim.api.nvim_win_get_cursor(0)[1]
  local current_line = vim.fn.getline(current_line_no)
  while current_line:gsub("%s+", "") == "" and current_line_no > 1 do
    current_line_no = current_line_no - 1
    current_line = vim.fn.getline(current_line_no)
  end
  local current_pos = {
    current_line_no - 1,
    current_line:len() - 1
  }

  local current_node = vim.treesitter.get_node({ pos = current_pos })
  local root = tree:root()

  while current_node ~= root do
    if current_node:type() == "function_definition" then
      for child in current_node:iter_children() do
        if child:type() == "parameters" then
          local choice_list = {}

          for param in child:iter_children() do
            if param:type() == "identifier" then
              local param_name = vim.treesitter.get_node_text(param, 0)
              if param_name ~= "self" then
                table.insert(
                  choice_list,
                  sn(nil, { t("self."), i(1, param_name), t(" = " .. param_name)})
                )
              end
            elseif string.find(param:type(), "parameter") then
              for param_child in param:iter_children() do
                if param_child:type() == "identifier" then
                  local param_name = vim.treesitter.get_node_text(param_child, 0)
                  if param_name ~= "self" then
                    table.insert(
                      choice_list,
                      sn(nil, { t("self."), i(1, param_name), t(" = " .. param_name) })
                    )
                  end
                end
              end
            end
          end
          return choice_list
        end
      end
    end

    current_node = current_node:parent()
  end
end

local function in_ts_regions(regions)
  if #regions == 0 then
    return true
  end

  local parser = vim.treesitter.get_parser()
  local tree = parser:parse()[1]
  local root = tree:root()
  local current_pos = {
    vim.api.nvim_win_get_cursor(0)[1]-2,
    vim.api.nvim_win_get_cursor(0)[2]
  }
  if current_pos[1] < 0 then
    current_pos[1] = 0
  end
  local current_node = vim.treesitter.get_node({ pos = current_pos })

  while current_node ~= root do
    if current_node:type() == regions[1] then
      table.remove(regions, 1)
      if #regions == 0 then
        return true
      end
    end
    current_node = current_node:parent()
  end
  return false
end

return {

  -- # pyright: ignore[...]
  s({ trig = "Upyign", desc = "pyright ignore" },
  fmt("# pyright: ignore[{}]", i(1, "ignoredError"))),

  -- # type: ignore
  s({ trig = "Utyign", desc = "type ignore" },
  t("# type: ignore")),

  -- if __name__ == "__main__":
  --     ...
  s({ trig = "Uifmain", desc = "if name is name block" },
  fmt([[
    if __name__ == "__main__":
        {}
  ]], { i(0, "main()") })),

  -- try:
  --     ...
  -- except Exception...:
  --     ...
  s({ trig = "Utry", desc = "try ... except" },
  fmt([[
    try:
        {}
    except {}:
        {}
  ]], {
    d(1, get_visual, {}, { user_args = { "code" }}),
    c(2, {
      sn(nil, { i(1, "Exception"), t(" as "), i(2, "err") }),
      sn(nil, { i(1, "Exception") })
    }),
    i(3, "pass") })),

  -- self.... = ...
  s({ trig = "Uself", desc = "self... = ..." },
  d(1, function()
    local choices = gen_self_choices()
    if #choices == 0 then
      return sn(nil, i(1, "No parameters to assign..."))
    else
      return sn(nil, c(1, choices))
    end
  end), 
  { condition = function()
    return in_ts_regions({ "function_definition", "class_definition" })
  end,
  show_condition = function()
    return in_ts_regions({ "function_definition", "class_definition" })
  end }),

}
