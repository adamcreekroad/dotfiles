local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  lsp_zero.default_keymaps({ buffer = bufnr })
  lsp_zero.buffer_autoformat()
end)

lsp_zero.set_sign_icons({
  error = '✘',
  warn = '▲',
  hint = '⚑',
  info = '»'
})

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = { 'cssls', 'graphql', 'html', 'lua_ls', 'tsserver' }, -- Exclude anything that needs the tool manually installed
  handlers = {
    rust_analyzer = lsp_zero.noop,
    gopls = lsp_zero.noop,
    ruby_lsp = lsp_zero.noop,
  }
})


---- Default Configurations

lsp_zero.setup_servers({ 'cssls', 'graphql', 'html', 'gopls', 'html', 'lua_ls', 'ruby_lsp', 'rust_analyzer', 'tsserver' })


---- Custom Configurations
