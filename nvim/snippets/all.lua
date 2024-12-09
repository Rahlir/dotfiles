local function current_date()
  return os.date("%Y-%m-%d")
end

local function current_time()
  return os.date("%I:%M %p")
end

return {
  s({ trig = "Uname", desc = "my name" },
  t("Tadeáš Uhlíř")),

  s({ trig = "Usign", desc = "code signature" },
  t("by Tadeas Uhlir <tadeas.uhlir@gmail.com>")),

  s({ trig = "Utoday", desc = "today's date" },
  f(current_date, {})),

  s({ trig = "Utime", desc = "current time" },
  f(current_time, {})),

  s({ trig = "Utodo", desc = "todo comment" },
  d(1, function(args, snip)
      return sn(nil, {t(snip.env.LINE_COMMENT .. " TODO: "), i(1, "todo")})
    end)
  )
}
