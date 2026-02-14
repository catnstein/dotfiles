# knip.nvim

Neovim integration for the [Knip](https://knip.dev) language server. Detects unused files, dependencies, and exports in JavaScript/TypeScript projects.

## Requirements

- Neovim >= 0.11
- Node.js
- `@knip/language-server` (via [Volta](https://volta.sh), [Mason](https://github.com/williamboman/mason.nvim), npm, or npx)

## Installation

### lazy.nvim

```lua
{
  'your-username/knip.nvim',
  ft = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  opts = {},
}
```

### Native packages

```bash
git clone https://github.com/your-username/knip.nvim \
  ~/.local/share/nvim/site/pack/plugins/start/knip.nvim
```

```lua
require('knip').setup()
```

## Configuration

All options are optional. Defaults:

```lua
require('knip').setup({
  cmd = nil,                    -- override server command (string or table)
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  root_markers = { 'knip.json', 'knip.jsonc', 'package.json' },
  auto_start = true,            -- auto vim.lsp.enable('knip')
  diagnostics = {
    hide_on_insert = true,      -- hide diagnostics while typing
  },
  restart_on_save = true,       -- re-analyze after :w
  settings = { ... },           -- knip LSP settings (see doc/knip.txt)
  on_attach = nil,              -- extra callback after built-in on_attach
})
```

### Server resolution

The plugin finds the language server binary in this order:

1. **User-provided** `cmd` option
2. **Volta** global install (`~/.volta/tools/image/packages/...`)
3. **Mason** install (`~/.local/share/nvim/mason/packages/...`)
4. **npx** fallback (`npx @knip/language-server --stdio`)

## Zero-config (Neovim 0.11+)

The plugin ships `lsp/knip.lua` for auto-discovery. If you accept all defaults, just ensure the plugin is loaded and call:

```lua
vim.lsp.enable('knip')
```

## Health check

```vim
:checkhealth knip
```

## License

MIT
