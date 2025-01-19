local get_visual = require("rahlir").get_visual

return {

  s({ trig = "Ublock", desc = "code block" },
  fmt([[
    ```{}
    {}
    ```
    {}
  ]], { i(1, "lang"), i(2, "code"), i(0) })),

  s({ trig = "Uhl", desc = "highlight block" },
  fmt([[
    > [!{}]
    > {}

    {}
  ]], {
    c(1, { t("NOTE"), t("TIP"), t("IMPORTANT"), t("WARNING"), t("CAUTION") }),
    i(2, "Note that..."),
    i(0)
  }))

}, {

  s({ trig = ";B" },
  fmt("**{}**", d(1, get_visual))),

  s({ trig = ";I" },
  fmt("_{}_", d(1, get_visual)))

}
