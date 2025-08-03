-- left out from lspzero: cssls, html, eslint
vim.lsp.enable({ "pylsp", "gopls", "lua_ls", "rust_analyzer", "ts_ls", "solargraph", "jsonls", "graphql" })

vim.diagnostic.config({
  signs = {
    active = true,
    text = {
      [vim.diagnostic.severity.ERROR] = "✘",
      [vim.diagnostic.severity.WARN] = "▲",
      [vim.diagnostic.severity.HINT] = "⚑",
      [vim.diagnostic.severity.INFO] = "»",
    },
  },
  virtual_text = true,
  float = { border = "border" },
})

vim.opt.completeopt = { "menuone", "noselect", "popup" }

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP actions",
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if not client then
      return
    end

    local opts = { buffer = args.buf }
    vim.keymap.set('n', '<C-Space>', '<C-x><C-o>', opts)
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set({ 'n', 'x' }, 'gq', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set('n', 'grt', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'grd', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)

    if client:supports_method('textDocument/inlayHint') then
      vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
    end

    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
    end

    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = args.buf,
      callback = function()
        if client:supports_method("textDocument/formatting") then
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
        end

        if client:supports_method("textDocument/codeAction") then
          local function apply_code_action(action_type)
            local ctx = { only = action_type, diagnostics = {} }
            local actions = vim.lsp.buf.code_action({ context = ctx, apply = true, return_actions = true })

            -- only apply if code action is available
            if actions and #actions > 0 then
              vim.lsp.buf.code_action({ context = ctx, apply = true })
            end
          end
          apply_code_action({ "source.fixAll" })
          apply_code_action({ "source.organizeImports" })
        end
      end,
    })
  end,
})
