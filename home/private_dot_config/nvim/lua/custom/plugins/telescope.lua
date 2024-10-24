return {
  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'xvzc/chezmoi.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', cond = vim.g.have_nerd_font },
    },
    config = function()
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      local telescope = require 'telescope'
      local telescope_config = require 'telescope.config'
      local vimgrep_arguments = { unpack(telescope_config.values.vimgrep_arguments) }
      table.insert(vimgrep_arguments, '--hidden')
      table.insert(vimgrep_arguments, '--glob')
      table.insert(vimgrep_arguments, '!**/.git/*')
      local actions = require 'telescope.actions'
      local actions_layout = require 'telescope.actions.layout'
      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      telescope.setup {
        -- You can put your default mappings / updates / etc. in here
        defaults = {
          vimgrep_arguments = vimgrep_arguments,
          mappings = {
            n = {
              ['<M-t>'] = actions_layout.toggle_preview,
            },
            i = {
              ['<M-t>'] = actions_layout.toggle_preview,
            },
          },
        },
        pickers = {
          buffers = {
            mappings = {
              i = {
                ['<M-d>'] = actions.delete_buffer + actions.move_to_top,
              },
            },
          },
          find_files = {
            find_command = {
              'rg',
              '--files',
              '--hidden',
              '--glob',
              '!**/.git/*',
            },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'chezmoi')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'

      -- Custom search function
      local function find_files_from_project_git_root(opts)
        local function is_git_repo()
          vim.fn.system 'git rev-parse --is-inside-work-tree'
          return vim.v.shell_error == 0
        end
        local function get_git_root()
          local dot_git_path = vim.fn.finddir('.git', '.;')
          return vim.fn.fnamemodify(dot_git_path, ':h')
        end
        opts = opts or {}
        if is_git_repo() then
          opts = vim.tbl_extend('force', opts, {
            cwd = get_git_root(),
          })
        end
        builtin.find_files(opts)
      end

      -- Keymaps
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
      vim.keymap.set('n', '<leader>s:', builtin.commands, { desc = '[S]earch [:] available commands' })

      -- Git related
      vim.keymap.set('n', '<leader>sgc', builtin.git_commits, { desc = '[S]earch [G]it [C]ommits' })
      vim.keymap.set('n', '<leader>sgb', builtin.git_branches, { desc = '[S]earch [G]it [B]ranches' })
      vim.keymap.set('n', '<leader>sgs', builtin.git_status, { desc = '[S]earch [G]it [S]tatus' })

      -- File related
      vim.keymap.set('n', '<leader>sf', function()
        find_files_from_project_git_root()
      end, { desc = '[S]earch [F]iles' })
      vim.keymap.set('n', '<leader>sa', function()
        find_files_from_project_git_root { no_ignore = true }
      end, { desc = '[S]earch [A]ll Files' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>se', builtin.live_grep, { desc = '[S]earch by gr[E]p' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching chezmoi managed configuration files
      vim.keymap.set('n', '<leader>sc', telescope.extensions.chezmoi.find_files, { desc = '[S]earch [C]hezmoi Managed Files' })
    end,
  },
}
