local M = {}

local ratings = require("cpvim.commands.ratings")
local dashboard = require("cpvim.commands.dashboard")
local templates = require("cpvim.templates")
local config = require("cpvim.config")

templates.ensure_dir()
config.load()

vim.api.nvim_create_user_command("CPVim", function(opts)
  local args = opts.fargs
  if #args == 0 then
    vim.api.nvim_err_writeln("Usage: CPVim <command> [args]")
    return
  end

  local cmd = args[1]

  -- Subcommands
  if cmd == "dashboard" then
    dashboard.showDashboard()

  elseif cmd == "ratings" then
    ratings.show_ratings()

  elseif cmd == "set" then
    if #args < 3 then
      vim.api.nvim_err_writeln("Usage: CPVim set <key> <value>")
      return
    end
    local key = args[2]
    local value = table.concat(args, " ", 3)

    if tonumber(value) then
      value = tonumber(value)
    end

    config.set(key, value)
    vim.api.nvim_echo({ { ("cpvim: %s = %s"):format(key, value), "Normal" } }, false, {})

  elseif cmd == "reload" then
    config.load()
    vim.api.nvim_echo({{ "cpvim: config reloaded", "Normal" }}, false, {})

  elseif cmd == "templates" then
    local list = templates.list()
    if #list == 0 then
      vim.api.nvim_echo({{ "No templates found", "WarningMsg" }}, false, {})
    else
      vim.api.nvim_echo({{ "Templates: " .. table.concat(list, ", "), "Normal" }}, false, {})
    end

  else
    M.load_template(cmd)
  end
end, {
  nargs = "*",
  complete = function()
    return { "set", "dashboard", "ratings", "reload", "templates" }
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