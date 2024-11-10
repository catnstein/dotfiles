return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  opts = {
    -- add any options here
    -- fix for macro command not showing
    routes = {
      {
        view = 'cmdline',
        filter = { event = 'msg_showmode' },
      },
    },
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    'MunifTanjim/nui.nvim',
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    'rcarriga/nvim-notify',
  },
}
