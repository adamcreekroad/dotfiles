-- Native treesitter (Neovim 0.12+) — no plugin needed since nvim-treesitter
-- was archived (April 2026).
--   Parsers: ~/.local/share/nvim/site/parser/*.so, built by scripts/install-parsers.sh
--   Queries: vendored under nvim/queries/

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

-- Filetypes whose parser goes by a different name
vim.treesitter.language.register("bash", { "sh", "zsh" })
vim.treesitter.language.register("tsx", "typescriptreact")

local ignore_filetypes = {
  "dockerfile", -- Doesn't work quite right...
}

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("NativeTreesitter", { clear = true }),
  callback = function(event)
    if vim.tbl_contains(ignore_filetypes, event.match) then
      return
    end

    local lang = vim.treesitter.language.get_lang(event.match) or event.match
    if not vim.tbl_contains(parsers, lang) then
      return
    end

    pcall(vim.treesitter.start, event.buf, lang)
  end,
})
