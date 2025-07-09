local M = {}

local function format_diagnostic(diagnostic)
  return diagnostic.code and string.format('%s: %s', diagnostic.code, diagnostic.message) or diagnostic.message
end

M.virtual_text_config = {
  source = true,
  prefix = '➞',
  format = format_diagnostic,
}

M.default_config = {
  virtual_text = M.virtual_text_config,
  virtual_lines = {
    current_line = true,
  },
  signs = true,
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'if_many',
    header = '',
    prefix = '',
  },
}

function M.toggle_virtual_text(enabled)
  if enabled then
    vim.diagnostic.config { virtual_text = M.virtual_text_config }
  else
    vim.diagnostic.config { virtual_text = false }
  end
end

function M.setup()
  vim.diagnostic.config(M.default_config)

  vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
    desc = 'Hide virtual text when cursor is on diagnostic line',
    group = vim.api.nvim_create_augroup('diagnostic-cursor', { clear = true }),
    callback = function()
      local cursor_line = vim.fn.line '.' - 1
      local diagnostics = vim.diagnostic.get(0, { lnum = cursor_line })
      M.toggle_virtual_text(#diagnostics == 0)
    end,
  })
end

M.setup()

return M
