---@module 'lazy'
---@type LazySpec
return {
  {
    'ibhagwan/fzf-lua',
    cmd = 'FzfLua',
    keys = {
      {
        '<leader>fb',
        function()
          local opts = {
            winopts = {
              height = 0.6,
              width = 0.5,
              preview = { vertical = 'up:70%' },
              -- Disable Treesitter highlighting for the matches
              treesitter = {
                enabled = false,
              },
            },
            fzf_opts = {
              ['--layout'] = 'reverse',
            },
          }

          -- Use grep when in normal mode and blines in visual mode since the former doesn't support
          -- searching inside visual selections.
          -- See https://github.com/ibhagwan/fzf-lua/issues/2051
          local mode = vim.api.nvim_get_mode().mode
          if vim.startswith(mode, 'n') then
            require('fzf-lua').lgrep_curbuf(opts)
          else
            require('fzf-lua').blines(opts)
          end
        end,
        desc = 'Search current buffer',
        mode = { 'n', 'x' },
      },
      { '<leader>fB', '<cmd>FzfLua buffers<cr>', desc = 'Buffers' },
      { '<leader>fc', '<cmd>FzfLua highlights<cr>', desc = 'Highlights' },
      { '<leader>fd', '<cmd>FzfLua lsp_document_diagnostics<cr>', desc = 'Document diagnositcs' },
      { '<leader>ff', '<cmd>FzfLua files<cr>', desc = 'Find files' },
      { '<leader>fg', '<cmd>FzfLua live_grep<cr>', desc = 'Grep' },
      { '<leader>fg', '<cmd>FzfLua grep_visual<cr>', desc = 'Grep', mode = 'x' },
      { '<leader>fh', '<cmd>FzfLua help_tags<cr>', desc = 'Help' },
      { '<leader>fr', '<cmd>FzfLua oldfiles<cr>', desc = 'Recently opened files' },
      { 'z=', '<cmd>FzfLua spell_suggest<cr>', desc = 'Spelling suggestions' },
      {
        '<C-x><C-f>',
        function()
          require('fzf-lua').complete_path {
            winopts = {
              height = 0.4,
              width = 0.5,
              relative = 'cursor',
            },
          }
        end,
        desc = 'Fuzzy complete path',
        mode = 'i',
      },
    },
    opts = function()
      local actions = require 'fzf-lua.actions'

      return {
        keymap = {
          builtin = {
            true,
            ['<C-/>'] = 'toggle-help',
            ['<C-m>'] = 'toggle-fullscreen',
            ['<C-i>'] = 'toggle-preview',
          },
          fzf = {
            true,
            ['alt-s'] = 'toggle',
            ['alt-a'] = 'toggle-all',
            ['ctrl-i'] = 'toggle-preview',
          },
        },
        defaults = { git_icons = false },
        -- Configuration for specific pickers
        files = {
          winopts = {
            ['preview.hidden'] = true,
          },
        },
        grep = {
          hidden = true,
          rg_opts = '--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -g "!.git" -e',
        },
        helptags = {
          actions = {
            -- Open help pages in a vertical split.
            ['enter'] = actions.help_vert,
          },
        },
        oldfiles = {
          include_current_session = true,
          winopts = {
            ['preview.hidden'] = true,
          },
        },
      }
    end,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(items, opts, on_choice)
        local ui_select = require 'fzf-lua.providers.ui_select'

        -- Register the fzf-lua picker the first time we call select.
        if not ui_select.is_registered() then
          ui_select.register(function(ui_opts)
            if ui_opts.kind == 'luasnip' then
              ui_opts.prompt = 'Snippet choice: '
              ui_opts.winopts = {
                relative = 'cursor',
                height = 0.35,
                width = 0.3,
              }
            elseif ui_opts.kind == 'color_presentation' then
              ui_opts.winopts = {
                relative = 'cursor',
                height = 0.35,
                width = 0.3,
              }
            else
              ui_opts.winopts = { height = 0.5, width = 0.4 }
            end

            -- Use the kind (if available) to set the previewer's title.
            if ui_opts.kind then
              ui_opts.winopts.title = string.format(' %s ', ui_opts.kind)
            end

            -- Ensure that there's a space at the end of the prompt.
            if ui_opts.prompt and not vim.endswith(ui_opts.prompt, ' ') then
              ui_opts.prompt = ui_opts.prompt .. ' '
            end

            return ui_opts
          end)
        end

        -- Don't show the picker if there's nothing to pick.
        if #items > 0 then
          return vim.ui.select(items, opts, on_choice)
        end
      end
    end,
  },
}
