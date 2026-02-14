local M = {}

M.defaults = {
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  root_markers = { 'knip.json', 'knip.jsonc', 'package.json' },
  auto_start = true,

  restart = {
    on_save = true,
  },
  settings = {
    knip = {
      enabled = true,
      editor = {
        exports = {
          codelens = { enabled = false },
          hover = { enabled = true, maxSnippets = 3, timeout = 300 },
          quickfix = { enabled = true },
          highlight = { dimExports = false, dimTypes = false },
        },
      },
    },
  },
  on_attach = nil,
}

--- @param user_opts table|nil
--- @return table
function M.resolve(user_opts)
  return vim.tbl_deep_extend('force', M.defaults, user_opts or {})
end

return M
