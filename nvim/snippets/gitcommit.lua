return {

  s({ trig = "Uchng", desc = "changelog trailer" },
  fmt("Changelog: {}", {
    c(1, {
      t("added"),
      t("fixed"),
      t("changed"),
      t("performance"),
      t("deprecated"),
      t("removed"),
      t("security"),
      t("other")
    })
  })),

  s({ trig = "Uconvent", desc = "conventional commits" },
  fmt("{}{}: {}", {
    c(1, {
      t("feat"),
      t("fix"),
      t("chore"),
      t("build"),
      t("ci"),
      t("docs"),
      t("perf"),
      t("refactor"),
      t("revert"),
      t("style"),
      t("test")
    }),
    i(2),
    i(3, "message")
  }))

}
