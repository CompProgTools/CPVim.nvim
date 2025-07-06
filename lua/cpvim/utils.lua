local M = {}

function M.parse_json(str)
  local ok, json = pcall(vim.fn.json_decode, str)
  if not ok then
    return nil
  end
  return json
end

return M