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
    vim.keymap.set("n", "<space>fh", builtin.help_tags, { desc = "Telescope find help files" })
    vim.keymap.set("n", "<space>ff", builtin.find_files, { desc = "Telescope find files in current dir" })
    vim.keymap.set("n", "<space>fb", builtin.buffers, { desc = "Telescope find buffers" })
    vim.keymap.set("n", "<space>fs", builtin.lsp_document_symbols, { desc = "Telescope find symbols" })
    vim.keymap.set("n", "<space>fr", builtin.lsp_references, { desc = "Telescope find references" })
    vim.keymap.set("n", "<space>fc", builtin.current_buffer_fuzzy_find, { desc = "Telescope find current buffer" })
    vim.keymap.set("n", "<space>fk", builtin.keymaps, { desc = "Telescope find keymaps" })
    vim.keymap.set("n", "<space>en", function()
      require("telescope.builtin").find_files({
        cwd = vim.fn.stdpath("config"),
      })
    end, { desc = "Telescope find neovim lua config files" })
    vim.keymap.set("n", "<space>ep", function()
      require("telescope.builtin").find_files({
        cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"),
      })
    end, { desc = "Telescope find lazy plugins" })
    require("config.telescope.multigrep").setup()
  end,
}
