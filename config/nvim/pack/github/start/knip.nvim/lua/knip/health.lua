local M = {}

function M.check()
  vim.health.start 'knip.nvim'

  if vim.fn.has 'nvim-0.11' == 1 then
    vim.health.ok('Neovim >= 0.11 (' .. tostring(vim.version()) .. ')')
  else
    vim.health.error('Neovim >= 0.11 required, got ' .. tostring(vim.version()))
  end

  if vim.fn.executable 'npx' == 1 then
    vim.health.ok 'npx found in PATH'
  else
    vim.health.error 'npx not found in PATH (required to run @knip/language-server)'
  end

  if vim.fn.executable 'node' == 1 then
    local node_v = vim.fn.system('node --version'):gsub('%s+', '')
    vim.health.ok('node found: ' .. node_v)
  else
    vim.health.warn 'node not found in PATH'
  end

  local clients = vim.lsp.get_clients { name = 'knip' }
  if #clients > 0 then
    vim.health.ok(#clients .. ' active knip client(s)')
    for _, c in ipairs(clients) do
      local root = c.config.root_dir or '(no root)'
      vim.health.info('  Client ' .. c.id .. ' attached to ' .. root)
    end
  else
    vim.health.info 'No active knip clients (open a JS/TS file to start)'
  end
end

return M
