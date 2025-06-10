-- Auto reinstall
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- Automatically run: PackerCompile
vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("PACKER", { clear = true }),
  pattern = "plugins.lua",
  command = "source <afile> | PackerCompile",
})

return require("packer").startup(function(use)
  -- Packer
  use("wbthomason/packer.nvim")

  -- Common utilities
  use("nvim-lua/plenary.nvim")

  -- Icons
  use("nvim-tree/nvim-web-devicons")

  -- Colorschema
  use("rebelot/kanagawa.nvim")
  use("olimorris/onedarkpro.nvim")

  use({
    "lukas-reineke/indent-blankline.nvim",
    config = function()
      require("ibl").setup()
    end,
  })

  -- Statusline
  use({
    "nvim-lualine/lualine.nvim",
    event = "BufEnter",
    config = function()
      require("configs.lualine")
    end,
    requires = { "nvim-web-devicons" },
  })

  -- Treesitter
  use({
    "nvim-treesitter/nvim-treesitter",
    run = function()
      require("nvim-treesitter.install").update({ with_sync = true })
    end,
    config = function()
      require("configs.treesitter")
    end,
  })

  -- use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" })

  -- Telescope
  use({
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    requires = { { "nvim-lua/plenary.nvim" } },
  })

  -- File manager
  use({
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
  })

  -- Show colors
  use({
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({ "*" })
    end,
  })

  -- Terminal
  use({
    "akinsho/toggleterm.nvim",
    tag = "*",
    config = function()
      require("configs.toggleterm")
    end,
  })

  -- Git
  use({
    "lewis6991/gitsigns.nvim",
    config = function()
      require("configs.gitsigns")
    end,
  })

  -- Markdown Preview
  use({
    "iamcco/markdown-preview.nvim",
    run = function()
      vim.fn["mkdp#util#install"]()
    end,
  })

  -- Auto pairs
  use({
    "windwp/nvim-autopairs",
    config = function()
      require("configs.autopairs")
    end,
  })

  -- Vim Test
  -- use({
  --   "vim-test/vim-test",
  --   config = function()
  --     require("configs.vim-test")
  --   end,
  -- })
  use({
    "nvim-neotest/neotest",
    requires = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",
      "olimorris/neotest-rspec",
    },
    config = function()
      require("configs.neotest")
    end,
  })

  use("tpope/vim-rails")

  -- Git
  use("tpope/vim-fugitive")
  use("tpope/vim-rhubarb")

  use("slim-template/vim-slim")

  -- Comment
  use({
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  })

  -- Folding
  use({
    "kevinhwang91/nvim-ufo",
    config = function()
      require("configs.ufo")
    end,
    requires = "kevinhwang91/promise-async",
  })

  if packer_bootstrap then
    require("packer").sync()
  end
end)
