-- GIT
return {
  -- {
  --   'tpope/vim-fugitive',
  -- },
  --
  {
    'kdheepak/lazygit.nvim',
    lazy = true,
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
  },
  -- See `:help gitsigns` to understand what the configuration keys do
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      on_attach = function(bufnr)
        local gs = require 'gitsigns'

        -- Navigation
        vim.keymap.set('n', ']h', gs.next_hunk, { buffer = bufnr, desc = 'Next git hunk' })
        vim.keymap.set('n', '[h', gs.prev_hunk, { buffer = bufnr, desc = 'Previous git hunk' })
        vim.keymap.set('n', 'ls', gs.stage_hunk, { buffer = bufnr, desc = 'Stage hunk' })
        vim.keymap.set('n', 'lu', gs.undo_stage_hunk, { buffer = bufnr, desc = 'Undo stage hunk' })
        vim.keymap.set('n', 'lb', gs.stage_buffer, { buffer = bufnr, desc = 'Stage buffer' })
        vim.keymap.set('n', 'lp', gs.preview_hunk, { buffer = bufnr, desc = 'Stage buffer' })
      end,
      signs = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
      signs_staged = {
        add = { text = '┃' },
        change = { text = '┃' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
        untracked = { text = '┆' },
      },
    },
  },
}
