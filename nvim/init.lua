require("settings")
require("plugins")
require("maps")
require("lsp")

-- colorscheme config: onedarkpro
local themeStatus, onedarkpro = pcall(require, "onedarkpro")

if themeStatus then
  onedarkpro.setup({
    highlights = {
      Comment = { italic = true },
      Directory = { bold = true },
      ErrorMsg = { italic = true, bold = true }
    },
    styles = {
      types = "NONE",
      methods = "NONE",
      numbers = "NONE",
      strings = "NONE",
      comments = "italic",
      keywords = "bold",
      constants = "NONE",
      functions = "bold",
      operators = "NONE",
      variables = "NONE",
      parameters = "NONE",
      conditionals = "bold",
      virtual_text = "NONE",
    },
    options = {
      cursorline = true
    },
  })

  vim.cmd("colorscheme onedark")
else
  return
end

vim.env.PATH = vim.env.HOME .. "/.local/share/mise/shims:" .. vim.env.PATH


-- Add ruby magic comment to the top of the file, since rubocop won't autocorrect it
function rfs()
  local pos = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_win_set_cursor(0, { 1, 0 })
  vim.api.nvim_buf_set_lines(0, 0, 0, false, { '# frozen_string_literal: true', '' })
  pos[1] = pos[1] + 2
  vim.api.nvim_win_set_cursor(0, pos)
end

vim.api.nvim_set_keymap('n', '<leader>rfs', '<cmd>lua rfs()<cr>', {})

-- Enable spellcheck
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = "*",
  command = "setlocal spell spelllang=en_us",
})
