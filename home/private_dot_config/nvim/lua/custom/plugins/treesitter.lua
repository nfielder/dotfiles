return {
  -- Highlight, edit, and navigate code
  {
    'nvim-treesitter/nvim-treesitter',
    version = false, -- last release is too old
    build = ':TSUpdate',
    main = 'nvim-treesitter.configs', -- Sets main module to use for opts
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    opts = {
      ensure_installed = {
        'bash',
        'c',
        'diff',
        'dockerfile',
        'git_rebase',
        'gitattributes',
        'gitignore',
        'gitcommit',
        'hcl',
        'html',
        'java',
        'json',
        'lua',
        'markdown',
        'regex',
        'templ',
        'toml',
        'vim',
        'vimdoc',
        'yaml',
      },
      -- Autoinstall languages that are not installed
      auto_install = true,
      highlight = {
        enable = true,
        disable = function()
          local buf_ft = vim.bo.filetype
          -- check if 'filetype' option includes 'chezmoitmpl'
          if buf_ft:match 'chezmoitmpl' then
            return true
          end
        end,
        -- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
        --  If you are experiencing weird indenting issues, add the language to
        --  the list of additional_vim_regex_highlighting and disabled languages for indent.
        additional_vim_regex_highlighting = { 'ruby' },
      },
      indent = {
        enable = true,
        disable = { 'ruby' },
      },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    event = 'VimEnter',
    cmd = { 'TSContextEnable', 'TSContextDisable', 'TSContextToggle' },
    opts = {
      mode = 'cursor',
      max_lines = 10,
    },
    keys = {
      { '<leader>tc', '<cmd>TSContextToggle<CR>', desc = '[T]oggle Treesitter [C]ontext', mode = 'n', silent = true },
      {
        '[c',
        function()
          require('treesitter-context').go_to_context(vim.v.count1)
        end,
        desc = 'Jump to context upwards',
        mode = 'n',
        silent = true,
      },
    },
  },
}
