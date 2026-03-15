return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- nvim 0.11+: treesitter highlight/indent are built-in, just install parsers
      local ensure = { "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" }
      local installed = require("nvim-treesitter").get_installed()
      local installed_set = {}
      for _, lang in ipairs(installed) do
        installed_set[lang] = true
      end
      local to_install = {}
      for _, lang in ipairs(ensure) do
        if not installed_set[lang] then
          table.insert(to_install, lang)
        end
      end
      if #to_install > 0 then
        vim.cmd("TSInstall " .. table.concat(to_install, " "))
      end
    end,
  },
}
