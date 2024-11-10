return {
  'folds.nvim',
  enabled = false,
  config = function()
    vim.keymap.set('n', '<leader>tr', "<cmd>lua require('folds').fold()<CR>")

    -- vim.api.nvim_create_autocmd('BufEnter', {
    --   callback = function()
    --     require('folds').fold()
    --   end,
    -- })

    vim.opt.runtimepath:prepend(vim.fn.expand '~/work/me/folds.nvim/')
  end,
}
