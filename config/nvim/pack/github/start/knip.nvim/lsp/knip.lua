local knip = require 'knip'

local lsp_config = knip.get_lsp_config()
if lsp_config then
  return lsp_config
end

return {}
