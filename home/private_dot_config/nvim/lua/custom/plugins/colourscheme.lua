return {
  -- Colourschemes
  {
    'EdenEast/nightfox.nvim',
    lazy = false,
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      vim.cmd.colorscheme [[carbonfox]]

      -- You can configure highlights by doing something like:
      vim.cmd.hi [[Comment gui=none]]
    end,
  },
  {
    'NLKNguyen/papercolor-theme',
    event = 'VeryLazy',
  },
  {
    'rebelot/kanagawa.nvim',
    event = 'VeryLazy',
    opts = {
      background = {
        dark = 'dragon',
        light = 'lotus',
      },
    },
  },
}
