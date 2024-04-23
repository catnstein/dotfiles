return {
  'ThePrimeagen/harpoon',
  opts = {},
  config = function()
    local harpoon_ui = require 'harpoon.ui'
    local harpoon_mark = require 'harpoon.mark'

    local function navToFile(number)
      return function()
        harpoon_ui.nav_file(number)
      end
    end

    -- TODO: add desc and maybe `which-key` config
    vim.keymap.set('n', '<leader>ho', harpoon_ui.toggle_quick_menu, { desc = 'Toggle harpoon menu' })
    -- Add current file to harpoon
    vim.keymap.set('n', '<leader>ha', harpoon_mark.add_file)

    -- Remove current file from harpoon
    vim.keymap.set('n', '<leader>hr', harpoon_mark.rm_file)

    -- Remove all files from harpoon
    vim.keymap.set('n', '<leader>hc', harpoon_mark.clear_all)

    -- Quickly jump to harpooned files
    vim.keymap.set('n', '<leader>1', navToFile(1))

    vim.keymap.set('n', '<leader>2', navToFile(2))

    vim.keymap.set('n', '<leader>3', navToFile(3))

    vim.keymap.set('n', '<leader>4', navToFile(4))

    vim.keymap.set('n', '<leader>5', navToFile(5))
  end,
}
