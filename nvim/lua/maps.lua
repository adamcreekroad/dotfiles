local function map(mode, lhs, rhs)
  vim.keymap.set(mode, lhs, rhs, { silent = true })
end

local status, telescope = pcall(require, "telescope.builtin")
if status then
  -- Telescope
  map("n", "<leader>ff", telescope.find_files)
  map("n", "<leader>fg", telescope.live_grep)
  map("n", "<leader>fb", telescope.buffers)
  map("n", "<leader>fh", telescope.help_tags)
  map("n", "<leader>fs", telescope.git_status)
  map("n", "<leader>fc", telescope.git_commits)
else
  print("Telescope not found")
end

-- Save
map("n", "<leader>w", "<CMD>update<CR>")

-- Quit
map("n", "<leader>q", "<CMD>q<CR>")

-- Exit insert mode
map("i", "jk", "<ESC>")

-- Windows
map("n", "<leader>n", "<CMD>vsplit<CR>")
map("n", "<leader>p", "<CMD>split<CR>")

-- NeoTree
map("n", "<leader>e", "<CMD>Neotree toggle<CR>")
map("n", "<leader>o", "<CMD>Neotree focus<CR>")

-- Buffer
map("n", "<TAB>", "<CMD>bnext<CR>")
map("n", "<S-TAB>", "<CMD>bprevious<CR>")

-- Terminal
map("n", "<leader>th", "<CMD>ToggleTerm size=10 direction=horizontal<CR>")
map("n", "<leader>tv", "<CMD>ToggleTerm size=80 direction=vertical<CR>")

-- Markdown Preview
map("n", "<leader>m", "<CMD>MarkdownPreview<CR>")
map("n", "<leader>mn", "<CMD>MarkdownPreviewStop<CR>")

-- Window Navigation
map("n", "<C-h>", "<C-w>h")
map("n", "<C-l>", "<C-w>l")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-j>", "<C-w>j")

-- Resize Windows
map("n", "<C-Left>", "<C-w><")
map("n", "<C-Right>", "<C-w>>")
map("n", "<C-Up>", "<C-w>+")
map("n", "<C-Down>", "<C-w>-")

-- Test
map("n", "<leader>t", "<CMD>TestNearest<CR>")
map("n", "<leader>T", "<CMD>TestFile<CR>")
map("n", "<leader>a", "<CMD>TestSuite<CR>")
map("n", "<leader>l", "<CMD>TestLast<CR>")
map("n", "<leader>g", "<CMD>TestVisit<CR>")

-- Toggle LSP diagnostics
local _show_virtual_text = true
map("n", "<leader>gv", function()
  if _show_virtual_text then
    vim.diagnostic.show(nil, nil, nil, { virtual_text = false })
    _show_virtual_text = false
  else
    vim.diagnostic.show(nil, nil, nil, { virtual_text = true })
    _show_virtual_text = true
  end
end, opts)


map("t", "<esc>", "<C-\\><C-n>")
