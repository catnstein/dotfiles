-- TypeScript/JavaScript specific keybindings
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == 'ts_ls' then
      local bufnr = args.buf

      -- Organize imports
      vim.keymap.set('n', '<leader>oi', function()
        vim.lsp.buf.execute_command {
          command = '_typescript.organizeImports',
          arguments = { vim.api.nvim_buf_get_name(0) },
        }
      end, { buffer = bufnr, desc = 'Organize imports' })

      -- Remove unused variables/imports
      vim.keymap.set('n', '<leader>ru', function()
        vim.lsp.buf.code_action {
          apply = true,
          context = {
            only = { 'source.removeUnused.ts' },
            diagnostics = {},
          },
        }
      end, { buffer = bufnr, desc = 'Remove unused' })
    end
  end,
})
