-- Autoformat
return {
  'stevearc/conform.nvim',
  opts = {
    notify_on_error = true,
    async = true,
    format_on_save = {
      timeout_ms = 4500,
      lsp_fallback = true,
    },
    stop_after_first = true,
    formatters_by_ft = {
      lua = { 'stylua' },
      -- Conform can also run multiple formatters sequentially
      -- python = { "isort", "black" },
      --
      -- You can use a sub-list to tell conform to run *until* a formatter
      -- is found.
      javascript = { 'prettier' },
      typescript = { 'prettierd', 'prettier' },
      html = { 'prettier' },
      json = { 'prettier' },
      css = { 'prettierd', 'prettier' },
      go = { 'gofumpt' },
      formatters = {
        gofumpt = {
          command = 'gofumpt',
          args = { '$FILENAME' },
          stdin = false,
        },
      },
    },
    config = function(_, opts)
      local conform = require 'conform'

      conform.setup(opts)
    end,
  },
}
