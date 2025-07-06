-- This file ensures the plugin is loaded when Neovim starts
if vim.g.loaded_cpvim then
    return
end
vim.g.loaded_cpvim = 1

-- Load the main plugin modules
require("lua.cpvim.commands.cpvim")
require("lua.cpvim.commands.ratings")
require("lua.cpvim.commands.dashboard")