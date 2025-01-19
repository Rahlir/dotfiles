return {

  s({ trig = "Upython", desc = "standard python gitignore" },
  fmt([[
    # Byte-compiled / optimized / DLL files
    __pycache__/
    *.py[cod]
    *$py.class

    # Unit test / coverage reports
    htmlcov/
    .tox/
    .nox/
    .coverage
    .coverage.*
    .cache
    coverage.xml
    .pytest_cache/

    # Virtualenv
    venv/
    .venv/
  ]], {})),

  s({ trig = "Uenv", desc = ".env gitignore" },
  fmt([[
    # .env files
    .env*
  ]], {}))

}
