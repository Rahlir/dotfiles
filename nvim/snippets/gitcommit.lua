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
  }))

}
