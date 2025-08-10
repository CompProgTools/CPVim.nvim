if vim.g.loaded_cpvim then
  return
end
vim.g.loaded_cpvim = 1

-- Load config FIRST
require("cpvim.config").load()

-- Then load commands
require("cpvim.commands.cpvim")
require("cpvim.commands.ratings")
require("cpvim.commands.dashboard")