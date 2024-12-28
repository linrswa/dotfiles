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
      },
    })

    vim.keymap.set("n", "<space>ff", vim.lsp.buf.format, {})
  end,
}
