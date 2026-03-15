require("config.lazy")

vim.filetype.add({
  extension = {
    v = "verilog",
  },
})

vim.wo.number = true
vim.wo.relativenumber = true
vim.opt.shiftwidth = 4

-- Use OSC52 for clipboard when connected via SSH
if vim.env.SSH_TTY then
  local osc52 = require("vim.ui.clipboard.osc52")

  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = osc52.copy("+"),
      ["*"] = osc52.copy("*"),
    },
    paste = {
      ["+"] = function()
        return { vim.fn.split(vim.fn.getreg("+"), "\n"), vim.fn.getregtype("+") }
      end,
      ["*"] = function()
        return { vim.fn.split(vim.fn.getreg("*"), "\n"), vim.fn.getregtype("*") }
      end,
    },
  }

  vim.opt.clipboard = "unnamedplus"
else
  vim.opt.clipboard = "unnamedplus"
end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")

vim.keymap.set("n", "<space>j", "<cmd>cnext<CR>")
vim.keymap.set("n", "<space>k", "<cmd>cprev<CR>")
vim.keymap.set("n", "<space>nh", "<cmd>nohl<CR>")
vim.diagnostic.config({ virtual_text = true })

-- Highlight when yanking (copying) text
-- Try it with 'yap' in nomral mode
-- See ':help vim.highlight.on_yank()'
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
