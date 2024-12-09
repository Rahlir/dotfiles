local get_visual = require("rahlir").get_visual

local in_mathzone = function()
  return vim.fn['vimtex#syntax#in_mathzone']() == 1
end

local in_text = function()
  return not in_mathzone()
end

return {

  s({ trig = "Ubeg", desc = "begin ... end environment" },
  fmta([[
    \begin{<>}
      <>
    \end{<>}
  ]], { i(1, "envname"), i(2, "content"), rep(1) })
  ),

  s({ trig = "Ueq", desc = "equation environment" },
  fmta([[
    \begin{equation}
      <>
    \end{equation}
  ]], { i(1) }), { condition = in_text, show_condition = in_text }),

  s({ trig = "Ueq*", desc = "equation* environment" },
  fmta([[
    \begin{equation*}
      <>
    \end{equation*}
  ]], { i(1) }),
  { condition = in_text, show_condition = in_text }),

  s({ trig = '(%a)(%d)', regTrig = true, desc = "auto subscript" },
  fmta("<>_<>", {
    f(function(_, snip) return snip.captures[1] end),
    f(function(_, snip) return snip.captures[2] end)
  }), { condition = in_mathzone }),

  s({ trig = '(%a)(%d%d)', regTrig = true, desc = "auto subscript for 2+ digits" },
  fmta("<>_{<>}", {
    f(function(_, snip) return snip.captures[1] end),
    f(function(_, snip) return snip.captures[2] end)
  }), { condition = in_mathzone }),

  s({ trig = '(%a)^(%d%d)', regTrig = true, desc = "auto exponent for 2+ digits" },
  fmta("<>^{<>}", {
    f(function(_, snip) return snip.captures[1] end),
    f(function(_, snip) return snip.captures[2] end)
  }), { condition = in_mathzone }),

}, {

  s(";a", t("\\alpha")),

  s(";b", t("\\beta")),

  s(";g", t("\\gamma")),

  s(";d", t("\\delta")),

  s(";f", fmta("\\frac{<>}{<>}", { i(1), i(2) }), { condition = in_mathzone }),

  s(";I", fmta("\\textit{<>}", d(1, get_visual)), { condition = in_text }),

  s(";B", fmta("\\textbf{<>}", d(1, get_visual)), { condition = in_text }),

  s(";U", fmta("\\underline{<>}", d(1, get_visual)), { condition = in_text }),
}
