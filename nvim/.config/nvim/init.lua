require("config.lazy")

vim.wo.number = true
vim.wo.relativenumber = true
vim.opt.shiftwidth = 4
vim.opt.clipboard = "unnamedplus"

vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")

vim.keymap.set("n", "<space>j", "<cmd>cnext<CR>")
vim.keymap.set("n", "<space>k", "<cmd>cprev<CR>")

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
