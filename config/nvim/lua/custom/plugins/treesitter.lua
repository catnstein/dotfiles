-- Highlight, edit, and navigate code
return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    local ok, treesitter = pcall(require, 'nvim-treesitter')

    if not ok or not treesitter.install then
      return
    end

    local parsers = { 'bash', 'c', 'html', 'lua', 'markdown', 'markdown_inline', 'vim', 'vimdoc', 'query', 'regex' }
    local installed = {}

    for _, parser in ipairs(treesitter.get_installed('parsers')) do
      installed[parser] = true
    end

    local missing = {}

    for _, parser in ipairs(parsers) do
      if not installed[parser] then
        table.insert(missing, parser)
      end
    end

    if #missing > 0 then
      treesitter.install(missing, { max_jobs = 1 })
    end

    vim.api.nvim_create_autocmd('FileType', {
      pattern = { 'bash', 'c', 'html', 'lua', 'markdown', 'sh', 'vim', 'vimdoc' },
      callback = function()
        pcall(vim.treesitter.start)

        if vim.bo.filetype ~= 'markdown' then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
