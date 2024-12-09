return {

  s({ trig = "Upyign", desc = "pyright ignore" },
  fmt("# pyright: ignore[{}]", i(1, "ignoredError"))),

  s({ trig = "Utyign", desc = "type ignore" },
  t("# type: ignore"))

}
