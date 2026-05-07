local status, ts = pcall(require, "nvim-treesitter")
if not status then
  return
end


local parsers = {
  "bash",
  "c",
  "cpp",
  "css",
  "go",
  "graphql",
  "html",
  "javascript",
  "json",
  "liquid",
  "lua",
  "markdown",
  "nginx",
  "python",
  "rbs",
  "regex",
  "ruby",
  "rust",
  "scss",
  "slim",
  "sql",
  "terraform",
  "toml",
  "tsx",
  "typescript",
  "yaml",
}

ts.install(parsers)


local ignore_filetypes = {
  'dockerfile' -- Doesn't work quite right...
}

vim.api.nvim_create_autocmd('FileType', {
  callback = function(event)
    if vim.tbl_contains(ignore_filetypes, event.match) then
      return
    end

    if not vim.tbl_contains(parsers, event.match) then
      return
    end

    local ok = pcall(function()
      vim.treesitter.start(event.buf)
    end)
    if not ok then
    end
  end,
})

--ts.setup({
--  highlight = {
--    enable = true,
--    additional_vim_regex_highlighting = false,
--    disable = {
--      "dockerfile" -- doesn't quite work right...
--    }
--  },
--  context_commentstring = {
--    enable = true,
--    enable_autocmd = false,
--  },
--  ensure_installed = {
--    "bash",
--    "c",
--    "cpp",
--    "css",
--    "dockerfile",
--    "go",
--    "graphql",
--    "html",
--    "javascript",
--    "json",
--    "liquid",
--    "lua",
--    "markdown",
--    "nginx",
--    "python",
--    "rbs",
--    "regex",
--    "ruby",
--    "rust",
--    "scss",
--    "slim",
--    "sql",
--    "terraform",
--    "toml",
--    "tsx",
--    "typescript",
--    "yaml",
--  },
--  rainbow = {
--    enable = true,
--    disable = { "html" },
--    extended_mode = false,
--    max_file_lines = nil,
--  },
--  autotag = { enable = true },
--  incremental_selection = { enable = true },
--  indent = { enable = true },
--})
--
--local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
--parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }
