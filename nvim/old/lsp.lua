local status, nvim_lsp = pcall(require, "lspconfig")
if not status then
    return
end

local protocol = require("vim.lsp.protocol")

local on_attach = function(client, bufnr)
    -- format on save
    if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("Format", { clear = true }),
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format()
            end,
        })
        vim.api.nvim_create_autocmd("BufWritePre", {
          pattern = "ruby",
          callback = function()
              vim.lsp.buf.format()
          end,
        })
    end
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- TypeScript
nvim_lsp.tsserver.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

-- CSS
nvim_lsp.cssls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

-- Tailwind
nvim_lsp.tailwindcss.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

-- Ruby

-- textDocument/diagnostic support until 0.10.0 is released
_timers = {}
local function setup_diagnostics(client, buffer)
  if require("vim.lsp.diagnostic")._enable then
    return
  end

  local diagnostic_handler = function()
    local params = vim.lsp.util.make_text_document_params(buffer)
    client.request("textDocument/diagnostic", { textDocument = params }, function(err, result)
      if err then
        local err_msg = string.format("diagnostics error - %s", vim.inspect(err))
        vim.lsp.log.error(err_msg)
      end
      if not result then
        return
      end
      vim.lsp.diagnostic.on_publish_diagnostics(
        nil,
        vim.tbl_extend("keep", params, { diagnostics = result.items }),
        { client_id = client.id }
      )
    end)
  end

  diagnostic_handler() -- to request diagnostics on buffer when first attaching

  vim.api.nvim_buf_attach(buffer, false, {
    on_lines = function()
      if _timers[buffer] then
        vim.fn.timer_stop(_timers[buffer])
      end
      _timers[buffer] = vim.fn.timer_start(200, diagnostic_handler)
    end,
    on_detach = function()
      if _timers[buffer] then
        vim.fn.timer_stop(_timers[buffer])
      end
    end,
  })

  vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
      vim.lsp.buf.format()
    end,
  })
end

-- nvim_lsp.rubocop.setup{}
nvim_lsp.ruby_ls.setup({
 on_attach = function(client, buffer)
   setup_diagnostics(client, buffer)
 end,
})

-- Golang
nvim_lsp.gopls.setup({
  capabilities = capabilities,
  on_attach = on_attach,
})

-- YAML
nvim_lsp.yamlls.setup{}

