local M = {}

local ratings = require("cpvim.commands.ratings")
local dashboard = require("cpvim.commands.dashboard")
local templates = require("cpvim.templates")
templates.ensure_dir()

vim.api.nvim_create_user_command("CPVim", function(opts)
  local args = vim.split(opts.args, "%s+")
  local command = args[1]

  if command == "ratings" then
    ratings.show_ratings()
  elseif command == "dashboard" then
    dashboard.showDashboard()
  elseif command and command ~= "" then
    M.load_template(command)
  else
    vim.api.nvim_err_writeln("Usage: CPVim <template> | CPVim ratings | CPVim dashboard")
  end
end, {
  nargs = 1,
  complete = function()
    return { "ratings", "dashboard" } ++ templates.list()
  end
})

M.load_template = function(name)
  local content = templates.load(name)
  if not content then
    vim.api.nvim_err_writeln("Template not found: " .. name)
    return
  end

  local curr_name = vim.fn.expand("%:t")
  if curr_name == "" then
    local base = name:match("(.+)%..+$") or name
    local ext = name:match("%.([^%.]+)$") or "cpp"
    local new_name = base .. "Main." .. ext
    vim.cmd("edit " .. new_name)
  end

  vim.api.nvim_buf_set_lines(0, 0, -1, false, content)
  vim.api.nvim_echo({ { "Template loaded: " .. name, "Normal" } }, false, {})
end

return M