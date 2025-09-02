return {
  {
    'nvim-mini/mini.files',
    dependencies = {
      'nvim-mini/mini.icons',
    },
    opts = {
      mappings = {
        go_in_plus = '<CR>',
        go_out = 'H',
        go_out_plus = 'h',
      },
      content = {
        --- Custom filter to hide '.git' directory in file explorer
        ---@param fs_entry { fs_type: 'file'|'directory', name: string, path: string }
        ---@return boolean
        filter = function(fs_entry)
          if fs_entry.fs_type == 'directory' and fs_entry.name == '.git' then
            return false
          end
          return true
        end,
      },
      windows = {
        preview = true,
        width_focus = 35,
        width_preview = 50,
      },
    },
    keys = {
      -- TODO: Move common logic for mini.files into util module
      {
        '<leader>e',
        function()
          local mini_files = require 'mini.files'
          -- close explorer if it is opened
          if mini_files.close() then
            return
          end
          -- use cwd if filetype is ministarter
          local use_cwd = false
          if vim.bo.filetype:match 'ministarter' then
            use_cwd = true
          end
          local buf_path = vim.api.nvim_buf_get_name(0)
          local path = not use_cwd and buf_path or vim.uv.cwd()
          mini_files.open(path, true)
        end,
        desc = 'Open file [E]xplorer (Dir of current file)',
      },
      {
        '<leader>E',
        function()
          local mini_files = require 'mini.files'
          if not mini_files.close() then
            mini_files.open(vim.uv.cwd(), true)
          end
        end,
        desc = 'Open file [E]xplorer (cwd)',
      },
    },
  },
}
