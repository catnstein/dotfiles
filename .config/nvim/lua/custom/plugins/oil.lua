return {
  'stevearc/oil.nvim',
  opts = {
    view_options = {
      show_hidden = true,
    },
    keymaps = {
      ['<C-s>'] = false,
      ['<C-h>'] = false,
      ['<C-l>'] = false,
    },
  },
  -- TODO: enable split and vsplit
  -- config = function()
  --   local actions = require 'oil.actions'
  --
  --   -- vim.keymap.set('n', '<C-->', actions.select_split.callback, { desc = 'Select split' })
  --   -- vim.keymap.set('n', '<C-|>', actions.select_vsplit.callback, { desc = 'Select vsplit' })
  -- end,
  -- Optional dependencies
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}
