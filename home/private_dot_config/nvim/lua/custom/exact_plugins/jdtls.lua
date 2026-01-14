-- This is the same as in lspconfig.configs.jdtls, but avoids
-- needing to require that when this module loads.
local java_filetypes = { 'java' }
local helpers = require 'custom.helpers'

-- Utility function to extend or override a config table, similar to the way
-- that Plugin.opts works.
---@param config table
---@param custom function | table | nil
local function extend_or_override(config, custom, ...)
  if type(custom) == 'function' then
    config = custom(config, ...) or config
  elseif custom then
    config = vim.tbl_deep_extend('force', config, custom) --[[@as table]]
  end
  return config
end

---@module 'lazy'
---@type LazySpec
return {
  'mfussenegger/nvim-jdtls',
  dependencies = {
    'saghen/blink.cmp',
    'mason-org/mason.nvim',
  },
  ft = java_filetypes,
  cond = function()
    local ok, mason_registry = pcall(require, 'mason-registry')
    if not ok then
      -- Disable if unable to determine if package installed via mason-registry
      return false
    end

    local packages = mason_registry.get_installed_package_names()
    for _, p in pairs(packages) do
      if p == 'jdtls' then
        -- Return early if package found in list
        return true
      end
    end

    -- If not found, then return false
    return false
  end,
  opts = function()
    local cmd = { vim.fn.exepath 'jdtls' }
    if helpers.has_plugin 'mason.nvim' then
      local lombok_jar = vim.fn.expand '$MASON/packages/jdtls' .. '/lombok.jar'
      table.insert(cmd, string.format('--jvm-arg=-javaagent:%s', lombok_jar))
    end
    return {
      root_dir = vim.fs.root(0, { '.git', 'mvnw', 'gradlew' }),
      project_name = function(root_dir) return root_dir and vim.fs.basename(root_dir) end,
      jdtls_config_dir = function(project_name) return vim.fn.stdpath 'cache' .. '/jdtls/' .. project_name .. '/config' end,
      jdtls_workspace_dir = function(project_name) return vim.fn.stdpath 'cache' .. '/jdtls/' .. project_name .. '/workspace' end,
      cmd = cmd,
      full_cmd = function(opts)
        local fname = vim.api.nvim_buf_get_name(0)
        local root_dir = opts.root_dir(fname)
        local project_name = opts.project_name(root_dir)
        local extended_cmd = vim.deepcopy(opts.cmd)
        if project_name then
          vim.list_extend(extended_cmd, {
            '-configuration',
            opts.jdtls_config_dir(project_name),
            '-data',
            opts.jdtls_workspace_dir(project_name),
          })
        end
        return extended_cmd
      end,
    }
  end,
  config = function(_, opts)
    local function attach_jdtls()
      local fname = vim.api.nvim_buf_get_name(0)
      local config = extend_or_override({
        settings = {
          java = {
            format = {
              enabled = false,
            },
          },
        },
        cmd = opts.full_cmd(opts),
        root_dir = opts.root_dir(fname),
        capabilities = require('blink.cmp').get_lsp_capabilities(nil, true),
      }, opts.jdtls)

      require('jdtls').start_or_attach(config)
    end

    -- Attach the jdtls for each java buffer. HOWEVER, this plugin loads
    -- depending on filetype, so this autocmd doesn't run for the first file.
    -- For that, we call directly below.
    vim.api.nvim_create_autocmd('FileType', {
      pattern = java_filetypes,
      callback = attach_jdtls,
    })

    -- Avoid race condition by calling attach the first time, since the autocmd won't fire
    attach_jdtls()
  end,
}
