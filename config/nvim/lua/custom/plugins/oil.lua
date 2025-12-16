vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open parent directory' })

return {
  'stevearc/oil.nvim',
  opts = {
    view_options = {
      show_hidden = true,
    },
    lsp_file_methods = {
      timeout_ms = 60000,
      autosave_changes = false,
    },
    keymaps = {
      ['<C-s>'] = false,
      ['<C-h>'] = false,
      ['<C-l>'] = false,
    },
  },
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}
