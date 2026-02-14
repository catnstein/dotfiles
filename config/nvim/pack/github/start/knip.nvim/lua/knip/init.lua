local config = require 'knip.config'

local M = {}

local DEFAULT_CMD = { 'npx', '@knip/language-server', '--stdio' }

--- @type table|nil
M._resolved_config = nil

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

    if opts.diagnostics.hide_on_insert then
      vim.api.nvim_create_autocmd('InsertEnter', {
        group = knip_augroup,
        buffer = bufnr,
        callback = function()
          vim.diagnostic.hide(knip_ns, bufnr)
        end,
      })

      vim.api.nvim_create_autocmd('InsertLeave', {
        group = knip_augroup,
        buffer = bufnr,
        callback = function()
          vim.diagnostic.show(knip_ns, bufnr)
        end,
      })
    end

    if opts.restart_on_save then
      vim.api.nvim_create_autocmd('BufWritePost', {
        group = knip_augroup,
        buffer = bufnr,
        callback = function()
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
--- @return table
function M.get_lsp_config()
  local opts = M._resolved_config or config.resolve()
  return {
    cmd = DEFAULT_CMD,
    filetypes = opts.filetypes,
    root_markers = opts.root_markers,
    settings = opts.settings,
    on_attach = build_on_attach(opts),
  }
end

--- @param opts table|nil
function M.setup(opts)
  M._resolved_config = config.resolve(opts)

  if vim.fn.executable 'npx' ~= 1 then
    vim.notify('knip.nvim: npx not found in PATH. Run :checkhealth knip for details.', vim.log.levels.WARN)
    return
  end

  vim.lsp.config('knip', M.get_lsp_config())

  if M._resolved_config.auto_start then
    vim.lsp.enable 'knip'
  end
end

return M
