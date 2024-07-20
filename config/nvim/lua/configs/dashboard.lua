local config = {
  theme = 'hyper',
  config = {
    packages = { enable = false },
    project = { enable = true, limit = 10},
    week_header = {
     enable = true,
    },
    shortcut = {
      -- { desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
      {
        icon = " ",
        desc = "Find Files",
        group = "@property",
        action = "Telescope find_files",
        key = "f",
      },
      {
        icon = " ",
        desc = "New File",
        group = "@property",
        action = [[ene | startinser]],
        key = "n",
      },
      {
        icon = " ",
        desc = "Recent Files",
        group = "@property",
        action = "Telescope oldfiles",
        key = "r",
      },
      {
        icon = " ",
        desc = "Quit",
        group = "Number",
        action = [[qa]],
        key = "q",
      },
    },
  },
}

require('dashboard').setup(config)
