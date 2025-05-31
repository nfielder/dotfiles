return {
  'L3MON4D3/LuaSnip',
  version = '2.*',
  build = (function()
    -- Build Step is needed for regex support in snippets.
    -- This step is not supported in many windows environments.
    -- Remove the below condition to re-enable on windows.
    if vim.fn.has 'win32' == 1 or require('custom.helpers').is_not_executable 'make' then
      return
    end
    return 'make install_jsregexp'
  end)(),
  opts = function()
    return {
      -- NOTE: This load_ft_func seems borked
      load_ft_func = require('luasnip.extras.filetype_functions').extend_load_ft {
        templ = { 'html' },
      },
    }
  end,
  config = function(_, opts)
    local ls = require 'luasnip'
    -- Also load html when templ is opened
    ls.filetype_extend('templ', { 'html' })
    ls.setup(opts)
  end,
}
