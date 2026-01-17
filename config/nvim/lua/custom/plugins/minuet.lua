return {
  {
    'milanglacier/minuet-ai.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('minuet').setup {
        provider = 'openai_fim_compatible',
        n_completions = 2,
        context_window = 2000,
        request_timeout = 3,
        throttle = 400,
        debounce = 100,
        notify = 'warn',

        virtualtext = {
          auto_trigger_ft = { 'lua', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' },
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
          gemini = {
            model = 'gemini-2.0-flash',
            api_key = 'GEMINI_API_KEY',
            optional = {
              generationConfig = {
                maxOutputTokens = 256,
              },
            },
          },
          openai_fim_compatible = {
            api_key = 'TERM',
            name = 'Ollama',
            end_point = 'http://localhost:11434/v1/completions',
            model = 'qwen2.5-coder:7b',
            stream = true,
            optional = {
              max_tokens = 256,
              top_p = 0.9,
            },
          },
        },

        presets = {
          gemini = {
            provider = 'gemini',
            context_window = 16000,
            request_timeout = 3,
            throttle = 1000,
            debounce = 400,
            n_completions = 3,
          },
          ollama = {
            provider = 'openai_fim_compatible',
            context_window = 2000,
            request_timeout = 4,
            throttle = 400,
            debounce = 100,
            n_completions = 2,
          },
        },
      }
    end,
  },
}
