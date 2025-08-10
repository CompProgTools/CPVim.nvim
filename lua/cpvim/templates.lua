-- lua/cpvim/templates.lua
local M = {}

local data_dir = vim.fn.stdpath("data") .. "/cpvim/templates"

function M.ensure_dir()
  vim.fn.mkdir(data_dir, "p", 0700)
end

function M.list()
  if vim.fn.isdirectory(data_dir) == 0 then
    return {}
  end
  return vim.fn.readdir(data_dir)
end

function M.load(name)
  local path = data_dir .. "/" .. name
  if vim.fn.filereadable(path) == 0 then
    return nil
  end
  return vim.fn.readfile(path)
end

return M