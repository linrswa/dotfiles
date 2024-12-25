return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    { 'nvim-telescope/telescope-ui-select.nvim'}
  },
  config = function()
    local telescope = require('telescope')
    telescope.setup {
      pickers = {
        find_files = {
          theme = 'ivy'
        }
      },
      extensions = {
        fzf = {},
        ['ui-select'] = {
          require('telescope.themes').get_dropdown()
        }
      }
    }

    telescope.load_extension('fzf')
    telescope.load_extension('ui-select')

    vim.keymap.set("n", "<space>fh", require('telescope.builtin').help_tags)
    vim.keymap.set("n", "<space>fd", require('telescope.builtin').find_files)
    vim.keymap.set("n", "<space>en", function()
      require('telescope.builtin').find_files {
        cwd = vim.fn.stdpath("config")
      }
    end)
    vim.keymap.set("n", "<space>ep", function()
      require('telescope.builtin').find_files {
        cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
      }
    end)
    require "config.telescope.multigrep".setup()
  end
}
