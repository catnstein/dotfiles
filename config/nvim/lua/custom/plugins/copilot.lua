return {
  {
    'zbirenbaum/copilot.lua',
    enabled = false,
    event = { 'BufEnter' },
    config = function()
      require('copilot').setup {
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 250,
          keymap = {
            accept = '<C-a>', -- Your custom accept key
            next = '<M-]>',
            prev = '<M-[>',
            dismiss = '<C-]>',
          },
        },
        panel = { enabled = false },
      }
    end,
  },
  {
    'zbirenbaum/copilot-cmp',
    enabled = false,
    event = { 'BufEnter' },
    dependencies = { 'zbirenbaum/copilot.lua' },
    config = function()
      require('copilot_cmp').setup()
    end,
  },
}
