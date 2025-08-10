local M = {}
local config = require("cpvim.config")

M.showDashboard = function()
    local cfg = config.current

    local name = cfg.name or "Anonymous"
    local leetcode = cfg.leetcode or "N/A"
    local codeforces = cfg.codeforces or "N/A"
    local leet_rating = cfg.leetcode_rating or "N/A"
    local cf_rating = cfg.codeforces_rating or "N/A"
    local language = cfg.preferred_language or "cpp"

    local buf = vim.api.nvim_create_buf(false, true)
    vim.cmd("rightbelow vsplit")
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)
    vim.api.nvim_win_set_width(win, 60)

    local lines = {
        "╭──────────────────────────────────────────────────────────────╮",
        string.format("│ Welcome, %-36s │", name),
        "│ │",
        string.format("│ AKA %-20s on LeetCode │", leetcode),
        string.format("│ and %-20s on Codeforces │", codeforces),
        "│ │",
        "│ Ratings: │",
        string.format("│ LeetCode: %-45s │", leet_rating),
        string.format("│ Codeforces: %-43s │", cf_rating),
        "│ │",
        string.format("│ Language: %-46s │", language),
        "│ │",
        "╰──────────────────────────────────────────────────────────────╯"
    }

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    vim.api.nvim_buf_set_option(buf, 'readonly', true)
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(buf, 'swapfile', false)
    vim.api.nvim_buf_set_name(buf, 'CP Dashboard')

    vim.api.nvim_win_set_option(win, 'wrap', false)
    vim.api.nvim_win_set_option(win, 'number', false)
    vim.api.nvim_win_set_option(win, 'relativenumber', false)
    vim.api.nvim_win_set_option(win, 'signcolumn', 'no')
    vim.api.nvim_win_set_option(win, 'foldcolumn', '0')
    vim.api.nvim_win_set_option(win, 'cursorline', false)

    local ns_id = vim.api.nvim_create_namespace("cpvimDashboard")

    vim.api.nvim_buf_add_highlight(buf, ns_id, "Title", 1, 0, -1)

    vim.api.nvim_buf_add_highlight(buf, ns_id, "Keyword", 3, 0, -1)
    vim.api.nvim_buf_add_highlight(buf, ns_id, "Keyword", 4, 0, -1)

    vim.api.nvim_buf_add_highlight(buf, ns_id, "Comment", 6, 0, -1)
    vim.api.nvim_buf_add_highlight(buf, ns_id, "String", 7, 0, -1)
    vim.api.nvim_buf_add_highlight(buf, ns_id, "String", 8, 0, -1)

    vim.api.nvim_buf_add_highlight(buf, ns_id, "Type", 10, 0, -1)

    local opts = { noremap = true, silent = true, buffer = buf }
    vim.keymap.set('n', 'q', '<cmd>close<cr>', opts)

    vim.api.nvim_echo({{"CP Dashboard loaded. Press 'q' to close.", "Normal"}}, false, {})
end

return M