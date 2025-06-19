return {
  -- Colourschemes
  {
    'EdenEast/nightfox.nvim',
    lazy = false,
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      vim.cmd.colorscheme [[carbonfox]]

      -- TODO: Use opts for these overrides. See https://github.com/EdenEast/nightfox.nvim/blob/main/readme.md#customize-palettes-and-groups
      -- Set nicer colours for TreesitterContext
      vim.cmd.hi [[TreesitterContext guibg=NvimDarkGray3]]
      vim.cmd.hi [[TreesitterContextLineNumber guifg=NvimLightYellow]]
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
