local M = {}

local function file_exists(path)
  return vim.uv.fs_stat(path) ~= nil
end

local function volta_path()
  local path = vim.fn.expand '~/.volta/tools/image/packages/@knip/language-server/lib/node_modules/@knip/language-server/src/index.js'
  if file_exists(path) then
    return { 'node', path, '--stdio' }
  end
end

local function mason_path()
  local path = vim.fn.stdpath 'data' .. '/mason/packages/knip-language-server/node_modules/@knip/language-server/src/index.js'
  if file_exists(path) then
    return { 'node', path, '--stdio' }
  end
end

local function npx_fallback()
  if vim.fn.executable 'npx' == 1 then
    return { 'npx', '@knip/language-server', '--stdio' }
  end
end

--- Resolve the knip language server command.
--- Checks in order: user-provided cmd, Volta global, Mason, npx fallback.
--- @param user_cmd string|string[]|nil
--- @return string[]|nil cmd
--- @return string|nil source description of where the server was found
function M.resolve(user_cmd)
  if user_cmd then
    local cmd = type(user_cmd) == 'string' and { user_cmd } or user_cmd
    return cmd, 'user config'
  end

  local cmd = volta_path()
  if cmd then
    return cmd, 'volta'
  end

  cmd = mason_path()
  if cmd then
    return cmd, 'mason'
  end

  cmd = npx_fallback()
  if cmd then
    return cmd, 'npx'
  end

  return nil, nil
end

return M
