return {
  init_options = {
    provideFormatter = true
  },
  cmd = { 'vscode-json-language-server', '--stdio' },
  filetypes = { 'json', 'jsonc' },
  root_markers = { '.git' }
}
