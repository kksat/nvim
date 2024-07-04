return {
  "nvim-neotest/neotest",
  optional = true,
  dependencies = {
    "nvim-neotest/neotest-python",
  },
  opts = {
    adapters = {
      ["neotest-python"] = {
        dap = { justMyCode = false },
        args = {"--log-level", "DEBUG"},
        runner = "pytest",
        python = ".venv/bin/python",
      },
    },
  },
}
