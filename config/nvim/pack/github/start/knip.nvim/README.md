# knip.nvim

Neovim integration for the [Knip](https://knip.dev) language server. Detects unused files, dependencies, and exports in JavaScript/TypeScript projects.

## Requirements

- Neovim >= 0.11
- Node.js
- `@knip/language-server` installed via [Volta](https://volta.sh) or [Mason](https://github.com/williamboman/mason.nvim)

```bash
volta install @knip/language-server
```

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
  filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
  root_markers = { 'knip.json', 'knip.jsonc', 'package.json' },
  auto_start = true,            -- auto vim.lsp.enable('knip')
  diagnostics = {
    hide_on_insert = true,      -- hide diagnostics while typing
  },
  restart = {
    on_save = true,             -- re-analyze after :w
    on_insert_leave = true,     -- re-analyze when leaving insert mode
  },
  settings = { ... },           -- knip LSP settings (see doc/knip.txt)
  on_attach = nil,              -- extra callback after built-in on_attach
})
```

### Server resolution

The plugin finds the language server in this order:

1. **Volta** global install (`~/.volta/tools/image/packages/...`)
2. **Mason** install (`~/.local/share/nvim/mason/packages/...`)

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
