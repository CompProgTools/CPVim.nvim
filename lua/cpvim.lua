vim.api.nvim_create_user_command("CPVim", function(opts))
    local alias = opts.args
    if alias == "" then
        vim.api.nvim_err_writeln("Usage: CPVim <template_filename")
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
}