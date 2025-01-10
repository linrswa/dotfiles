return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    { "nvim-telescope/telescope-ui-select.nvim" },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      extensions = {
        fzf = {},
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
      defaults = {
        file_ignore_patterns = {
          ".git/",
          "node_modules/",
          "build/",
          "vcpkg_installed/",
        },
      },
    })

    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")
    telescope.load_extension("noice")

    local builtin = require("telescope.builtin")
    vim.keymap.set("n", "<space>fh", builtin.help_tags)
    vim.keymap.set("n", "<space>ff", builtin.find_files)
    vim.keymap.set("n", "<space>fb", builtin.buffers)
    vim.keymap.set("n", "<space>fs", builtin.lsp_document_symbols)
    vim.keymap.set("n", "<space>en", function()
      require("telescope.builtin").find_files({
        cwd = vim.fn.stdpath("config"),
      })
    end)
    vim.keymap.set("n", "<space>ep", function()
      require("telescope.builtin").find_files({
        cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"),
      })
    end)
    require("config.telescope.multigrep").setup()
  end,
}
