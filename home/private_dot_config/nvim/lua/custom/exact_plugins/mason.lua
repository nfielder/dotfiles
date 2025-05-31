local helpers = require 'custom.helpers'

local function go_present()
  return helpers.is_executable 'go'
end

local function npm_present()
  return helpers.is_executable 'npm'
end

local function java_present()
  return helpers.is_executable 'java'
end

local function python3_present()
  return helpers.is_executable 'python3'
end

local packages = {
  language_servers = {
    ansiblels = { 'ansible-language-server', condition = npm_present },
    gopls = { 'gopls', condition = go_present },
    html = { 'html-lsp', condition = npm_present },
    jsonls = { 'json-lsp', condition = npm_present },
    jdtls = {
      'jdtls',
      condition = function()
        return java_present() and python3_present()
      end,
    },
    lua_ls = 'lua-language-server',
    pyright = { 'pyright', condition = npm_present },
    templ = { 'templ', condition = go_present },
    yamlls = { 'yaml-language-server', condition = npm_present },
  },
  formatters = {
    'stylua', -- Used to format Lua code
    'shfmt', -- Used to format shell code
    'yamlfmt', -- Used to format YAML files
  },
  linters = {
    { 'markdownlint-cli2', condition = npm_present }, -- Used to lint Markdown files
    { 'ansible-lint', condition = python3_present }, -- Used to lint Ansible related YAML files
    { 'yamllint', condition = python3_present }, -- Used to lint YAML files
  },
}

local tools_to_install = vim.iter({ vim.tbl_values(packages.language_servers), packages.formatters, packages.linters }):flatten(1):totable()

-- NOTE: Debug installed tools table
-- vim.notify(vim.inspect(tools_to_install), vim.log.levels.INFO, nil)

return {
  {
    'mason-org/mason.nvim',
    opts = {},
    dependencies = {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
    },
    init = function()
      -- Make mason packages available before loading it; allows to lazy load mason
      vim.env.PATH = vim.fn.stdpath 'data' .. '/mason/bin:' .. vim.env.PATH
      -- Do not crowd home directory with NPM cache folder
      vim.env.npm_config_cache = vim.env.HOME .. '/.cache/npm'
    end,
    config = function(_, opts)
      require('mason').setup(opts)

      require('mason-tool-installer').setup { ensure_installed = tools_to_install }
    end,
    keys = { { '<leader>pm', '<cmd>Mason<CR>', desc = '[M]ason home' } },
    event = 'VeryLazy',
  },
}
