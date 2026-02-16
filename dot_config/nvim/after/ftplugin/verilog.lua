-- Custom gd for Verilog: search from top of file for first occurrence of <cword>
vim.keymap.set("n", "gd", function()
  local word = vim.fn.expand('<cword>')
  local save_pos = vim.fn.getpos('.')
  vim.fn.cursor(1, 1)
  local found = vim.fn.search('\\<' .. vim.fn.escape(word, '\\') .. '\\>', 'cW')
  if found == 0 then
    vim.fn.setpos('.', save_pos)
    vim.notify('No declaration found for: ' .. word, vim.log.levels.WARN)
  end
end, { buffer = true, desc = "Go to first occurrence (Verilog)" })
