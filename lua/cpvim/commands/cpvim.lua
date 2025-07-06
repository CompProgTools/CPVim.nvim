local M = {}

vim.api.nvim_create_user_command("CPVim", function(opts)
    local alias = opts.args
    if alias == "" then
        vim.api.nvim_err_writeln("Usage: CPVim <template_filename>")
        return
    end

    M.load_template(alias)
end, {
    nargs = 1,
    complete = function(_, line)
        local home = os.getenv("HOME")
        local path = home .. "/.cpcli/templates"
        local handle = io.popen("ls " .. vim.fn.shellescape(path))
        if not handle then return {} end
        local result = handle:read("*a")
        handle:close()

        local files = {}
        for file in string.gmatch(result, "[^\n]+") do
            table.insert(files, file)
        end
        return files
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
        local ext = filename:match("%.([^%.]+)$") or "txt"
        local newName = base .. "Main." .. ext
        
        vim.api.nvim_command("edit " .. newName)
    end

    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.fn.split(content, "\n"))
end

function M.setup(opts)
end

return M