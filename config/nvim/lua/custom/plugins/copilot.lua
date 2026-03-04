return {
  'zbirenbaum/copilot.lua',
  cmd = 'Copilot',
  event = 'InsertEnter',
  config = function()
    require('copilot').setup {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true,
        debounce = 250,
        keymap = {
          accept = '<C-a>',
          accept_line = false,
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<C-]>',
        },
      },
      panel = { enabled = false },
      filetypes = {
        lua = true,
        javascript = true,
        typescript = true,
        javascriptreact = true,
        typescriptreact = true,
        ['*'] = false,
      },

    }
  end,
}
