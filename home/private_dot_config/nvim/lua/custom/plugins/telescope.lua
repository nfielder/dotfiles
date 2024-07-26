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
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
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
      local actions_layout = require 'telescope.actions.layout'
      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      telescope.setup {
        -- You can put your default mappings / updates / etc. in here
        defaults = {
          vimgrep_arguments = vimgrep_arguments,
          mappings = {
            n = {
              ['<leader>tp'] = actions_layout.toggle_preview,
            },
            i = {
              ['<A-t>'] = actions_layout.toggle_preview,
            },
          },
        },
        pickers = {
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
        -- pickers = {}
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
      vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
      vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
      vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
      vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

      vim.keymap.set('n', '<leader>sf', function()
        local function is_git_repo()
          vim.fn.system 'git rev-parse --is-inside-work-tree'
          return vim.v.shell_error == 0
        end
        local function get_git_root()
          local dot_git_path = vim.fn.finddir('.git', '.;')
          return vim.fn.fnamemodify(dot_git_path, ':h')
        end
        local opts = {}
        if is_git_repo() then
          opts = vim.tbl_extend('force', opts, {
            cwd = get_git_root(),
          })
        end
        builtin.find_files(opts)
      end, { desc = '[S]earch [F]iles' })

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
      -- vim.keymap.set('n', '<leader>sc', telescope.extensions.chezmoi.find_files, { desc = '[S]earch [C]hezmoi Managed Files' })
      vim.keymap.set('n', '<leader>sc', function()
        local chezmoi_commands = require 'chezmoi.commands'
        local make_entry = require 'telescope.make_entry'
        local action_state = require 'telescope.actions.state'
        local actions = require 'telescope.actions'
        local pickers = require 'telescope.pickers'
        local finders = require 'telescope.finders'

        local list = chezmoi_commands.list {
          args = {
            '--path-style',
            'absolute',
            '--include',
            'files',
            '--exclude',
            'externals',
          },
        }

        local opts = {}
        opts.cwd = os.getenv 'HOME'

        pickers
          .new(opts, {
            prompt_title = 'Chezmoi Files',
            finder = finders.new_table {
              results = list,
              entry_maker = make_entry.gen_from_file(opts),
            },
            attach_mappings = function(prompt_bufnr, map)
              local edit_action = function()
                actions.close(prompt_bufnr)
                local selection = action_state.get_selected_entry()
                chezmoi_commands.edit {
                  targets = selection.value,
                }
              end

              map('i', '<CR>', 'select_default')

              actions.select_default:replace(edit_action)
              return true
            end,
            previewer = telescope_config.values.file_previewer(opts),
            sorter = telescope_config.values.generic_sorter(opts),
          })
          :find()
      end, { desc = '[S]earch [C]hezmoi Managed Files' })
    end,
  },
}
