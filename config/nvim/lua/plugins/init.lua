return {
  {
    "stevearc/conform.nvim",
    -- event = 'BufWritePre', -- uncomment for format on save
    config = function()
      require("configs.conform")
    end,
  },

  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- require("nvchad.configs.lspconfig").defaults()
      require("configs.lspconfig")
    end,
  },
  --
  -- {
  -- 	"williamboman/mason.nvim",
  -- 	opts = {
  -- 		ensure_installed = {
  -- 			"lua-language-server", "stylua",
  -- 			"html-lsp", "css-lsp" , "prettier"
  -- 		},
  -- 	},
  -- },
  --
  -- 语法高亮插件
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "go",
        "python",
        "rust",
        "markdown",
        "dockerfile",
        "sql",
        "yaml",
        "toml",
      },
    },
  },

  -- indent lines
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- require("nvchad.configs.blankline").defaults()
      require("configs.blankline")
    end,
  },

  -- formatting , linting
  {
    "stevearc/conform.nvim",
    lazy = true,
    config = function()
      require("configs.conform")
    end,
  },

  -- dashboard
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    config = function()
      require("configs.dashboard")
    end,
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
  },

  -- https://github.com/kdheepak/lazygit.nvim
  -- git 功能插件
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    -- order to load the plugin when the command is run for the first time
  },
}
