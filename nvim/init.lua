require("settings")
require("plugins")
require("maps")

-- colorscheme config: onedarkpro
local themeStatus, onedarkpro = pcall(require, "onedarkpro")

if themeStatus then
  onedarkpro.setup({
    highlights = {
      Comment = { italic = true },
      Directory = { bold = true },
      ErrorMsg = { italic = true, bold = true }
    },
    plugins = {
      nvim_lsp = false,
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
    }
  })

  vim.cmd("colorscheme onedark")
else
  return
end
