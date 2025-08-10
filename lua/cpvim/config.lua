local utils = require("cpvim.utils")
local M = {}

M.defaults = {
  name = "Anonymous",
  leetcode = "",
  codeforces = "",
  leetcode_rating = nil,
  codeforces_rating = nil,
  preferred_language = "cpp",
}

local config_path = vim.fn.stdpath("config") .. "/cpvim/config.json"

function M.load()
  local file = io.open(config_path, "r")
  if not file then
    M.current = vim.deepcopy(M.defaults)
    M.save()
    return M.current
  end

  local content = file:read("*a")
  file:close()

  if not content or content == "" then
    M.current = vim.deepcopy(M.defaults)
    return M.current
  end

  local data = utils.parse_json(content)
  if data and type(data) == "table" then
    local cleaned = {}
    for k, v in pairs(data) do
      if M.defaults[k] ~= nil then
        cleaned[k] = v
      end
    end
    M.current = vim.tbl_extend("keep", cleaned, M.defaults)
  else
    M.current = vim.deepcopy(M.defaults)
  end

  return M.current
end

function M.save()
  local dir = vim.fn.stdpath("config") .. "/cpvim"
  vim.fn.mkdir(dir, "p", 0700) -- make sure permissions are secure

  local file = io.open(config_path, "w")
  if not file then
    vim.api.nvim_err_writeln("cpvim: could not write config to " .. config_path)
    return false
  end

  file:write(vim.fn.json_encode(M.current))
  file:close()

  return true
end

function M.set(key_or_table, value)
  if type(key_or_table) == "table" then
    for k, v in pairs(key_or_table) do
      if M.defaults[k] ~= nil then
        M.current[k] = v
      else
        vim.api.nvim_err_writeln("cpvim: invalid config key: " .. tostring(k))
      end
    end
  elseif M.defaults[key_or_table] ~= nil then
    M.current[key_or_table] = value
  else
    vim.api.nvim_err_writeln("cpvim: invalid config key: " .. tostring(key_or_table))
    return false
  end

  return M.save()  -- return true on success, false on failure
end

return M