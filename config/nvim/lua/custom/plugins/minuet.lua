local providers = {
  ollama = {
    name = 'openai_fim_compatible',
    config = {
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
    settings = {
      context_window = 2000,
      request_timeout = 4,
      throttle = 400,
      debounce = 100,
      n_completions = 2,
    },
  },
  gemini = {
    name = 'gemini',
    config = {
      model = 'gemini-2.0-flash',
      api_key = 'GEMINI_API_KEY',
      optional = {
        generationConfig = {
          maxOutputTokens = 256,
        },
      },
    },
    settings = {
      context_window = 16000,
      request_timeout = 3,
      throttle = 1000,
      debounce = 400,
      n_completions = 3,
    },
  },
}

local default_provider = 'ollama'

return {
  {
    'milanglacier/minuet-ai.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      require('minuet').setup {
        provider = providers[default_provider].name,
        n_completions = providers[default_provider].settings.n_completions,
        context_window = providers[default_provider].settings.context_window,
        request_timeout = providers[default_provider].settings.request_timeout,
        throttle = providers[default_provider].settings.throttle,
        debounce = providers[default_provider].settings.debounce,
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
          gemini = providers.gemini.config,
          openai_fim_compatible = providers.ollama.config,
        },

        presets = {
          gemini = vim.tbl_extend('force', { provider = providers.gemini.name }, providers.gemini.settings),
          ollama = vim.tbl_extend('force', { provider = providers.ollama.name }, providers.ollama.settings),
        },
      }
    end,
  },
}
