return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "dockerls", "pyright", "bashls", "clangd", "cmake" },
        automatic_installation = true,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "saghen/blink.cmp",
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
    },
    config = function()
      vim.lsp.config('*', {
        capabilities = require('blink.cmp').get_lsp_capabilities(),
      })
      vim.lsp.config('bashls', {
        filetypes = { "bash", "zsh", "sh" },
      })
      vim.lsp.config('pyright', {
        settings = {
          python = {
            pythonPath = vim.fn.exepath("python"),
          },
        },
      })
      vim.lsp.enable({ 'lua_ls', 'dockerls', 'bashls', 'pyright', 'clangd', 'cmake', 'hdl_checker' })

      require('render-markdown').setup({
        completions = { blink = { enabled = true } },
      })
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local buf = args.buf
          local ft = vim.bo[buf].filetype
          local opts = { buffer = buf }
          -- Verilog LSPs don't support intra-file go-to-definition well,
          -- so keep Vim's built-in gd for local declaration jump.
          if ft ~= "verilog" and ft ~= "systemverilog" then
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
          end
          vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
          vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
        end,
      })
    end,
  },
  {
    "github/copilot.vim",
  },
}
