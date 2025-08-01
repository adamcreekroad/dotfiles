return {
  cmd = { 'ruby-lsp' },
  filetypes = { 'ruby', 'eruby' },
  root_markers = { "Gemfile", ".git" },
  init_options = {
    formatter = nil,
    linters = { 'standard' },
  },
  single_file_support = true,
}
