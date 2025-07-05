vim.api.nvim_create_user_command("CPVim", function(opts))
    local alias = opts.args
    if alias == "" then
        vim.api.nvim_err_writeln("Usage: CPVim <template_filename")
        return
    end
    require("cpvim").load_template(alias)