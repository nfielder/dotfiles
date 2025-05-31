return {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  -- Main LSP configuration
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its  dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      --  This function gets run when an LSP attaches to a particular buffer.
      --    That is to say, every time a new file is opened that is associated with
      --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
      --    function will be executed to configure the current buffer

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          format = function(diagnostic)
            local diagnostic_message = {
              [vim.diagnostic.severity.ERROR] = diagnostic.message,
              [vim.diagnostic.severity.WARN] = diagnostic.message,
              [vim.diagnostic.severity.INFO] = diagnostic.message,
              [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
          end,
        },
      }

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      -- Enable the following language servers
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        -- clangd = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`ts_ls`) will work just fine
        -- ts_ls = {},
        --

        lua_ls = {
          -- cmd = {...},
          filetypes = { 'lua', 'lua.chezmoitmpl' },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
      }

      local helpers = require 'custom.helpers'
      -- Conditionally add language servers if npm is present
      if helpers.is_executable 'npm' then
        local extra_servers = {
          ansiblels = {
            settings = {
              redhat = {
                telemetry = {
                  enabled = false,
                },
              },
            },
          },
          pyright = {},
          jsonls = {},
          yamlls = {
            settings = {
              yaml = {
                keyOrdering = false,
              },
            },
          },
          html = {
            init_options = {
              provideFormatter = true,
            },
            settings = {
              html = {
                format = {
                  enable = true,
                },
              },
            },
            filetypes = { 'html', 'templ' },
          },
        }
        servers = vim.tbl_deep_extend('force', servers, extra_servers)
      end

      -- Conditionally add language servers if go is present
      if helpers.is_executable 'go' then
        local extra_servers = {
          gopls = {},
          -- NOTE: templ lsp installed via curl but has a dependency on gopls
          templ = {},
        }
        servers = vim.tbl_deep_extend('force', servers, extra_servers)
      end

      -- Ensure the servers and tools above are installed
      --
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.
      --
      --  `mason` had to be setup earlier: to configure its options see the
      --  `dependencies` table for `nvim-lspconfig` above.
      --
      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'shfmt', -- Used to format shell code
        'yamlfmt', -- Used to format YAML files
      })

      -- Conditionally add tools if npm is present
      if helpers.is_executable 'npm' then
        vim.list_extend(ensure_installed, {
          'markdownlint-cli2', -- Used to lint Markdown files
        })
      end

      -- Conditionally add tools if python3 is present
      if helpers.is_executable 'python3' then
        vim.list_extend(ensure_installed, {
          'ansible-lint', -- Used to lint Ansible related YAML files
          'yamllint', -- Used to lint YAML files
        })
      end

      -- Add java tools if java and python present
      -- TODO: Detect only install if Java version 21+
      if helpers.is_executable 'java' and helpers.is_executable 'python3' then
        vim.list_extend(ensure_installed, { 'jdtls' })
      end

      vim.keymap.set('n', '<leader>pm', '<cmd>Mason<CR>', { desc = '[M]ason home' })

      -- NOTE: below line to debug detected tools for installing via Mason
      -- vim.notify_once('Tools detected for installation by Mason: ' .. vim.inspect(ensure_installed), vim.log.levels.DEBUG, {})
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table (mason-tool-installer manages installs)
        automatic_installation = false,
        -- See :h mason-lspconfig-automatic-server-setup for more info
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
          ['jdtls'] = function()
            -- This LSP will be started by the nvim-jdtls plugin
            return true
          end,
        },
      }
    end,
  },
}
