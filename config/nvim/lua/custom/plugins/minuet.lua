return {
  {
    -- TODO: add proper configuratoin parameters
    -- based on hardware etc.
    'milanglacier/minuet-ai.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = { 'InsertEnter' },
    config = function()
      require('minuet').setup {
        provider = 'openai_fim_compatible',
        n_completions = 1,
        context_window = 512, -- Optimized for local 7B model
        request_timeout = 5, -- Increased for local model response time
        throttle = 1000,
        debounce = 1000, -- Slightly increased to reduce request frequency
        -- notify = 'debug', -- Temporarily enabled for troubleshooting

        -- Virtual text configuration (ghost text like Copilot)
        virtualtext = {
          auto_trigger_ft = { '*' }, -- FIXED: '*' enables all filetypes, {} disables all
          show_on_completion_menu = true,
          keymap = {
            accept = '<C-a>', -- Match your Copilot accept
            accept_line = '<C-l>', -- Accept single line
            prev = '<M-[>', -- Match your Copilot prev
            next = '<M-]>', -- Match your Copilot next
            dismiss = '<C-]>', -- Match your Copilot dismiss
          },
        },

        provider_options = {
          openai_fim_compatible = {
            api_key = 'TERM', -- Placeholder for Ollama
            name = 'Ollama',
            end_point = 'http://localhost:11434/v1/completions',
            model = 'qwen2.5-coder:7b',
            stream = true,
            optional = {
              max_tokens = 128, -- Reduced to prevent timeouts
              top_p = 0.9,
              stop = { '\n\n' },
            },
          },
        },
      }

      -- Enable virtualtext for the initial buffer
      vim.schedule(function()
        vim.b.minuet_virtual_text_auto_trigger = true
      end)
    end,
  },
}
