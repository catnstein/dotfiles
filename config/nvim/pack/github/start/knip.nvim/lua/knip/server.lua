local M = {}

local function file_exists(path)
  return vim.uv.fs_stat(path) ~= nil ---@diagnostic disable-line: undefined-field
end

-- TODO: need a better solution for this
local candidates = {
  {
    source = 'volta',
    path = vim.fn.expand '~/.volta/tools/image/packages/@knip/language-server/lib/node_modules/@knip/language-server/src/index.js',
  },
  {
    source = 'mason',
    path = vim.fn.stdpath 'data' .. '/mason/packages/knip-language-server/node_modules/@knip/language-server/src/index.js',
  },
}

--- Resolve the knip language server command.
--- @return string[]|nil cmd
--- @return string|nil source
function M.resolve()
  for _, c in ipairs(candidates) do
    if file_exists(c.path) then
      return { 'node', c.path, '--stdio' }, c.source
    end
  end
  return nil, nil
end

return M
