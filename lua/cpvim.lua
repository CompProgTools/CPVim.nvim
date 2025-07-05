vim.api.nvim_create_user_command("CPVim", function(opts)
    local alias = opts.args
    if alias == "" then
        vim.api.nvim_err_writeln("Usage: CPVim <template_filename>")
        return
    end
    require("cpvim").load_template(alias)
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

local M = {}

M.load_template = function(filename)
    local home = os.getenv("HOME")
    local path = home .. "/.cpcli/templates/" .. filename

    -- DEBUG print the path
    print("Trying to open: " .. path)

    local file = io.open(path, "r")
    if not file then
        vim.api.nvim_err_writeln("Template not found: " .. filename)
        return
    end

    local content = file:read("*a")
    file:close()

    vim.api.nvim_command("enew") -- open new buffer
    vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(content, "\n"))
end

return M