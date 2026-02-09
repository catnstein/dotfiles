vim.lsp.config('lua_ls', {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        version = 'LuaJIT',
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      diagnostics = {
        globals = { 'Snacks', 'snacks' },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
        -- Or pull in all of 'runtimepath'.
        -- NOTE: this is a lot slower and will cause issues when working on
        -- your own configuration.
        -- See https://github.com/neovim/nvim-lspconfig/issues/3189
        -- library = {
        --   vim.api.nvim_get_runtime_file('', true),
        -- }
      },
    })
  end,
  settings = {
    Lua = {},
  },
})
vim.lsp.config('ts_ls', {
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
})

-- Knip language server (global installation via Volta)
local knip_server_path = vim.fn.expand '~/.volta/tools/image/packages/@knip/language-server/lib/node_modules/@knip/language-server/src/index.js'

if vim.uv.fs_stat(knip_server_path) then
  vim.lsp.config('knip', {
    cmd = { 'node', knip_server_path, '--stdio' },
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    root_markers = { 'knip.json', 'knip.jsonc', 'package.json' },
    settings = {
      knip = {
        enabled = true,
        editor = {
          exports = {
            codelens = { enabled = false },
            hover = { enabled = true, maxSnippets = 3, timeout = 300 },
            quickfix = { enabled = true },
            highlight = { dimExports = false, dimTypes = false },
          },
        },
      },
    },
    on_attach = function(client, bufnr)
      -- Send knip.start request only once per client
      if not client._knip_started then
        client._knip_started = true
        client:request('knip.start', nil, function(err, result)
          if err then
            vim.notify('Knip start error: ' .. vim.inspect(err), vim.log.levels.WARN)
          end
        end, bufnr)
      end

      local knip_ns = vim.lsp.diagnostic.get_namespace(client.id)
      local knip_augroup = vim.api.nvim_create_augroup('KnipDiagnostics_' .. bufnr, { clear = true })

      -- Hide Knip diagnostics in insert mode
      vim.api.nvim_create_autocmd('InsertEnter', {
        group = knip_augroup,
        buffer = bufnr,
        callback = function()
          vim.diagnostic.hide(knip_ns, bufnr)
        end,
      })

      vim.api.nvim_create_autocmd('InsertLeave', {
        group = knip_augroup,
        buffer = bufnr,
        callback = function()
          vim.diagnostic.show(knip_ns, bufnr)
        end,
      })

      -- Refresh diagnostics after saving to clear fixed issues
      vim.api.nvim_create_autocmd('BufWritePost', {
        group = knip_augroup,
        buffer = bufnr,
        callback = function()
          client:request('knip.restart', nil, function() end, bufnr)
        end,
      })
    end,
  })
  vim.lsp.enable 'knip'
end
vim.lsp.enable 'ts_ls'
vim.lsp.enable 'html'
vim.lsp.enable 'gopls'
vim.lsp.enable 'pylsp'

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
