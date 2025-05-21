return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  lazy = true,
  version = false, -- set this if you want to always pull the latest change
  -- system_prompt as function ensures LLM always has latest MCP server state
  -- This is evaluated for every message, even in existing chats
  --

  opts = {
    --MCP related
    -- system_prompt = function()
    --   local hub = require('mcphub').get_hub_instance()
    --   return hub:get_active_servers_prompt()
    -- end,
    -- -- Using function prevents requiring mcphub before it's loaded
    -- --
    -- custom_tools = function()
    --   return {
    --     require('mcphub.extensions.avante').mcp_tool(),
    --   }
    -- end,
    --MCP related

    provider = 'ollama',
    -- provider = 'claude',
    cursor_applying_provider = 'ollama',
    behaviour = {
      enable_cursor_planning_mode = true, -- enable cursor planning mode!
    },
    ollama = {
      -- INFO: reasoning model instead
      -- model = 'deepseek-r1',
      -- model = 'codellama',
      -- model = 'qwen2.5-coder:32b',
      model = 'qwen2.5-coder:7b',

      -- for translations
      -- model = 'aya:8b',
    },
    -- TODO: not working yet
    rag_service = {
      enabled = false,
      runner = 'docker',
      -- host_mount = os.getenv 'HOME' .. '/Work', -- Host mount path for the rag service
      host_mount = '/Users/mirceabadragan/Work',
      provider = 'ollama', -- The provider to use for RAG service (e.g. openai or ollama)
      llm_model = 'llama3', -- The LLM model to use for RAG service
      embed_model = 'nomic-embed-text', -- The embedding model to use for RAG service
      endpoint = 'http://localhost:11434', -- The API endpoint for RAG service
    },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = 'make',
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    --- The below dependencies are optional,
    'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
    'zbirenbaum/copilot.lua', -- for providers='copilot'
    {
      -- support for image pasting
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          -- use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
      },
      ft = { 'markdown', 'Avante' },
    },
    'ravitemer/mcphub.nvim',
  },
}
