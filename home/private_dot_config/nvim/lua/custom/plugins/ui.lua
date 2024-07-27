return {
  -- Add indentation guides even on blank lines
  {
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},
  },
  {
    'stevearc/oil.nvim',
    cmd = 'Oil',
    dependencies = { 'echasnovski/mini.nvim' }, -- TODO: split out mini plugins individually
    opts = {
      default_file_explorer = false,
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name, _)
          return name == '.git'
        end,
      },
    },
  },
}
