local M = {}
local ratings = require("cpvim.commands.ratings")

vim.api.nvim_create_user_command("CPVim", function(opts)
    local args = vim.split(opts.args, "%s+")
    local command = args[1]
    
    if command == "ratings" then
        ratings.show_ratings()
    elseif command and command ~= "" then
        M.load_template(command)
    else
        vim.api.nvim_err_writeln("Usage: CPVim <template_filename> | CPVim ratings")
        return
    end
end, {
    nargs = 1,
    complete = function(_, line)
        local words = vim.split(line, "%s+")
        if #words <= 2 then
            -- First argument completion
            local completions = {"ratings"}
            
            -- Add template files
            local home = os.getenv("HOME")
            local path = home .. "/.cpcli/templates"
            local handle = io.popen("ls " .. vim.fn.shellescape(path) .. " 2>/dev/null")
            if handle then
                local result = handle:read("*a")
                handle:close()
                
                for file in string.gmatch(result, "[^\n]+") do
                    table.insert(completions, file)
                end
            end
            
            return completions
        end
        return {}
    end
})

M.load_template = function(filename)
    local home = os.getenv("HOME")
    local path = home .. "/.cpcli/templates/" .. filename

    local file = io.open(path, "r")
    if not file then
        vim.api.nvim_err_writeln("Template not found: " .. filename)
        return
    end

    local content = file:read("*a")
    file:close()

    local currName = vim.fn.expand("%:t")
    if currName == "" then
        local base = filename:match("(.+)%..+$") or filename
        local ext = filename:match("%.([^%.]+)$") or "cpp" -- Default to cpp instead of txt
        local newName = base .. "Main." .. ext
        
        vim.api.nvim_command("edit " .. newName)
    end

    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.fn.split(content, "\n"))
    vim.api.nvim_echo({{"Template loaded: " .. filename, "Normal"}}, false, {})
end

function M.setup(opts)
end

return M