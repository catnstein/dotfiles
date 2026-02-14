local config = require 'knip.config'
local server = require 'knip.server'

local M = {}

--- @type table|nil
M._resolved_config = nil
--- @type string[]|nil
M._resolved_cmd = nil
--- @type string|nil
M._cmd_source = nil

local function build_on_attach(opts)
  return function(client, bufnr)
    if not client._knip_started then
      client._knip_started = true
      client:request('knip.start', nil, function(err)
        if err then
          vim.notify('knip.nvim: start error: ' .. vim.inspect(err), vim.log.levels.WARN)
        end
      end, bufnr)
    end

    local knip_ns = vim.lsp.diagnostic.get_namespace(client.id)
    local knip_augroup = vim.api.nvim_create_augroup('KnipDiagnostics_' .. bufnr, { clear = true })
    local diag_filter = { ns_id = knip_ns, bufnr = bufnr }

    local function suppress_diagnostics()
      vim.diagnostic.enable(false, diag_filter)
    end

    local function restore_diagnostics()
      vim.diagnostic.enable(true, diag_filter)
    end

    vim.api.nvim_create_autocmd('InsertEnter', {
      group = knip_augroup,
      buffer = bufnr,
      callback = suppress_diagnostics,
    })

    vim.api.nvim_create_autocmd('InsertLeave', {
      group = knip_augroup,
      buffer = bufnr,
      callback = function()
        if not vim.bo[bufnr].modified then
          restore_diagnostics()
        end
      end,
    })

    vim.api.nvim_create_autocmd('TextChanged', {
      group = knip_augroup,
      buffer = bufnr,
      callback = suppress_diagnostics,
    })

    if opts.restart.on_save then
      vim.api.nvim_create_autocmd('BufWritePost', {
        group = knip_augroup,
        buffer = bufnr,
        callback = function()
          restore_diagnostics()
          client:request('knip.restart', nil, function() end, bufnr)
        end,
      })
    end

    if opts.on_attach then
      opts.on_attach(client, bufnr)
    end
  end
end

--- Build the vim.lsp.config spec table from resolved options.
--- @return table|nil lsp_config
function M.get_lsp_config()
  local opts = M._resolved_config or config.resolve()
  local cmd = M._resolved_cmd
  if not cmd then
    cmd = server.resolve()
  end
  if not cmd then
    return nil
  end

  return {
    cmd = cmd,
    filetypes = opts.filetypes,
    root_markers = opts.root_markers,
    settings = opts.settings,
    on_attach = build_on_attach(opts),
  }
end

--- @param opts table|nil
function M.setup(opts)
  M._resolved_config = config.resolve(opts)
  M._resolved_cmd, M._cmd_source = server.resolve()

  if not M._resolved_cmd then
    vim.notify('knip.nvim: language server not found. Install via: volta install @knip/language-server', vim.log.levels.WARN)
    return
  end

  local lsp_config = M.get_lsp_config()
  if not lsp_config then
    return
  end

  vim.lsp.config('knip', lsp_config)

  if M._resolved_config.auto_start then
    vim.lsp.enable 'knip'
  end
end

return M
