if vim.g.loaded_cpvim then
  return
end
vim.g.loaded_cpvim = 1

require("cpvim.config").load()
require("cpvim.commands.cpvim")
require("cpvim.commands.ratings")
require("cpvim.commands.dashboard")