-- [[ Basic Keymaps ]]
-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Inlay Hints
if vim.lsp.inlay_hint then
  vim.keymap.set('n', '<leader>ih', function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {})
  end, { desc = 'Toggle [I]nlay [H]ints' })
end
-- Save files
vim.keymap.set('n', '<C-s>', '<cmd>w<cr>', { desc = 'Save file' })
vim.keymap.set('n', '<C-S>', '<cmd>wa<cr>', { desc = 'Save all files' })

-- Disable Options
vim.keymap.set('n', 's', '<Nop>', { noremap = true, silent = true })
