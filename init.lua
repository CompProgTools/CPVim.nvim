local M = {}

function M.setup(opts)
  if opts then
    require("cpvim.config").set(opts)
  end
end

return M