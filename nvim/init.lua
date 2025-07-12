require("settings")
require("plugins")
require("maps")

vim.cmd("colorscheme tokyonight")

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
