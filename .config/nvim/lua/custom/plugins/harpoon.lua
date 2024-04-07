return {
  {
    'ThePrimeagen/harpoon',
    opts = {},
    config = function()
      local harpoon_ui = require 'harpoon.ui'
      vim.keymap.set('n', '<leader>ho', harpoon_ui.toggle_quick_menu, { desc = 'Toggle harpoon menu' })
      -- vim.keymap.set('v', '<leader>h', harpoon_ui.toggle_quick_menu, { desc = 'Toggle harpoon menu' })
      -- vim.keymap.set('i', '<leader>h', harpoon_ui.toggle_quick_menu, { desc = 'Toggle harpoon menu' })
      -- vim.keymap.set('n', '<leader>ho', { desc = 'Move focus to the upper window' })
      -- vim.keymap.set('n', '<leader>ho', { desc = 'Move focus to the upper window' })
      -- vim.keymap.set('n', '<leader>ho', { desc = 'Move focus to the upper window' })
      -- vim.keymap.set('n', '<leader>ho', { desc = 'Move focus to the upper window' })
      -- vim.keymap.set('n', '<leader>ho', { desc = 'Move focus to the upper window' })
      -- vim.keymap.set('n', '<leader>ho', { desc = 'Move focus to the upper window' })
    end,
  },
}
