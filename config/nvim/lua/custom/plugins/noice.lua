return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {
    routes = {
      {
        view = 'cmdline',
        filter = { event = 'msg_showmode' },
      },
      {
        filter = {
          event = 'msg_show',
          kind = '',
          find = 'written',
        },
        opts = { skip = true },
      },
      {
        filter = {
          event = 'notify',
          find = 'No information available',
        },
        opts = { skip = true },
      },
    },
  },
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
}
