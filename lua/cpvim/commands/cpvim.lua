local M = {}

local uv = vim.loop
local api = vim.api

local function ensure_templates_dir()
    local home = os.getenv("HOME")
    local templates_path = home .. "/.cpvim/templates"
    local stat = uv.fs_stat(templates_path)
    if not stat then
        uv.fs_mkdir(templates_path, 448) -- 0700 perms
    end
    return templates_path
end

vim.api.nvim_create_user_command("CPVim", function(opts)
    local args = vim.split(opts.args, "%s+")
    local templates_path = ensure_templates_dir()

    if args[1] == "create" then
        if not args[2] or args[2] == "" then
            api.nvim_err_writeln("Usage: CPVim create <template_filename>")
            return
        end
        local template_file = templates_path .. "/" .. args[2]
        local f = io.open(template_file, "r")
        if f then
            f:close()
            api.nvim_err_writeln("Template already exists: " .. args[2])
            return
        end
        f = io.open(template_file, "w")
        if not f then
            api.nvim_err_writeln("Failed to create template: " .. args[2])
            return
        end
        f:close()
        api.nvim_command("edit " .. template_file)
        api.nvim_echo({{"Template created: " .. args[2], "Normal"}}, false, {})
        return
    end

    local template_name = args[1]
    if template_name == "create" then
        return
    end

    if not template_name or template_name == "" then
        api.nvim_err_writeln("Usage: CPVim create <template_filename> | CPVim <template_filename> [<new_filename>]")
        return
    end

    local template_file = templates_path .. "/" .. template_name
    local f = io.open(template_file, "r")
    if not f then
        api.nvim_err_writeln("Template not found: " .. template_name)
        return
    end

    local content = f:read("*a")
    f:close()

    if args[2] and args[2] ~= "" then
        local new_file = args[2]
        local nf = io.open(new_file, "r")
        if nf then
            nf:close()
            api.nvim_err_writeln("File already exists: " .. new_file)
            return
        end
        nf = io.open(new_file, "w")
        if not nf then
            api.nvim_err_writeln("Failed to create file: " .. new_file)
            return
        end
        nf:write(content)
        nf:close()
        api.nvim_command("edit " .. new_file)
        api.nvim_echo({{"File created from template: " .. new_file, "Normal"}}, false, {})
    else
        local currName = vim.fn.expand("%:t")
        if currName == "" then
            local base = template_name:match("(.+)%..+$") or template_name
            local ext = template_name:match("%.([^%.]+)$") or "cpp"
            local newName = base .. "Main." .. ext
            api.nvim_command("edit " .. newName)
        end
        api.nvim_buf_set_lines(0, 0, -1, false, vim.fn.split(content, "\n"))
        api.nvim_echo({{"Template loaded: " .. template_name, "Normal"}}, false, {})
    end
end, {
    nargs = "+",
    complete = function(_, line)
        local words = vim.split(line, "%s+")
        local templates_path = ensure_templates_dir()
        local completions = {}

        if words[1] == "create" then
            return {}
        end

        if #words == 1 then
            table.insert(completions, "create")

            local handle = io.popen("ls " .. vim.fn.shellescape(templates_path) .. " 2>/dev/null")
            if handle then
                local result = handle:read("*a")
                handle:close()

                for file in string.gmatch(result, "[^\n]+") do
                    table.insert(completions, file)
                end
            end

            return completions
        elseif #words == 2 then
            return {}
        end

        return {}
    end
})

function M.setup(opts)
end

return M