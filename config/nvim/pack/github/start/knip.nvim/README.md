# knip.nvim

Neovim integration for the [Knip](https://knip.dev) language server. Detects unused files, dependencies, and exports in JavaScript/TypeScript projects.

## Requirements

- Neovim >= 0.11
- Node.js + npx

The language server (`@knip/language-server`) is run via `npx` automatically — no global install needed.

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
  restart_on_save = true,       -- re-analyze after :w
  settings = { ... },           -- knip LSP settings (see doc/knip.txt)
  on_attach = nil,              -- extra callback after built-in on_attach
})
```

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
