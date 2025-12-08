return {
  'folke/tokyonight.nvim',
  lazy = false, -- INFO: make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- INFO: make sure to load this before all the other start plugins
  config = function()
    vim.cmd.colorscheme 'catppuccin-mocha'
    vim.cmd.hi 'Comment gui=none'
  end,
}
