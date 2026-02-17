return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvimtools/none-ls-extras.nvim",
    "jayp0521/mason-null-ls.nvim",
  },
  config = function()
    require("mason-null-ls").setup({
      ensure_installed = {
        "ruff",
        "perttier",
        "shfmt",
      },
      automatic_install = true,
    })

    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        require("none-ls.formatting.ruff").with({ extra_args = { "--extend-select", "I" } }),
        require("none-ls.formatting.ruff_format"),
        null_ls.builtins.formatting.prettier.with({
          filetypes = { "json", "yaml", "markdown" },
        }),
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.shfmt.with({ extra_args = { "-i", "4" } }),
        null_ls.builtins.diagnostics.hadolint,
        null_ls.builtins.formatting.clang_format,
        null_ls.builtins.formatting.verible_verilog_format,
        {
          name = "verilator",
          method = null_ls.methods.DIAGNOSTICS,
          filetypes = { "verilog", "systemverilog" },
          generator = require("null-ls.helpers").generator_factory({
            command = "verilator",
            args = function(params)
              local dir = vim.fn.fnamemodify(params.bufname, ":h")
              return { "-lint-only", "-Wno-fatal", "-I" .. dir, "$FILENAME" }
            end,
            to_temp_file = true,
            from_stderr = true,
            format = "line",
            check_exit_code = function(code)
              return code <= 1
            end,
            on_output = function(line, params)
              local h = require("null-ls.helpers")
              local pattern = [[%%(%w+).-:(%d+):(%d+): (.*)]]
              local overrides = {
                severities = {
                  ["Error"] = 1,
                  ["Warning"] = 2,
                },
              }
              return h.diagnostics.from_pattern(pattern, { "severity", "row", "col", "message" }, overrides)(line, params)
            end,
          }),
        },
      },
    })

    vim.keymap.set("n", "<space>gf", vim.lsp.buf.format, {})
  end,
}
