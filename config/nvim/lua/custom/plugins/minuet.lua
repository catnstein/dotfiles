return {
  {
    'milanglacier/minuet-ai.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('minuet').setup {
        provider = 'openai_fim_compatible',
        n_completions = 1,
        context_window = 512,
        request_timeout = 10,
        throttle = 1000,
        debounce = 500,
        notify = 'debug',

        virtualtext = {
          auto_trigger_ft = { 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
          show_on_completion_menu = true,
          keymap = {
            accept = '<C-a>',
            accept_line = '<C-l>',
            prev = '<M-[>',
            next = '<M-]>',
            dismiss = '<C-]>',
          },
        },

        provider_options = {
          openai_fim_compatible = {
            api_key = 'TERM',
            name = 'Ollama',
            end_point = 'http://localhost:11434/v1/completions',
            model = 'qwen2.5-coder:7b',
            stream = true,
            optional = {
              max_tokens = 128,
              top_p = 0.9,
            },
          },
        },
      }
    end,
  },
}
