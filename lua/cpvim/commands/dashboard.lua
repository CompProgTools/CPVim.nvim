local M = {}
local utils = require('cpvim.utils')

M.showDashboard = function()
    local home = os.getenv("HOME")
    local configPath = home .. "/.cpcli/config.json"
    local streakPath = home .. "/.cpcli/streak.json"

    -- load the config
    local file = io.open(configPath, "r")
    if not file then
        vim.api.nvim_err_writeln("Config file not found: " .. configPath)
        return
    end

    local configContent = file:read("*a")
    file:close()

    local config = utils.parse_json(configContent)

    -- load streak
    local file2 = io.open(streakPath, "r")
    local highScore = "N/A"
    if file2 then
        local streakContent = file2:read("*a")
        file2:close()
        local streakConfig = utils.parse_json(streakContent)
        highScore = streakConfig.highscore or "N/A"
    end

    local name = config.name or "unknown"
    local leetcode = config.leetcode or "N/A"
    local cf = config.codeforces or "N/A"
    local leetRating = config.leetcode_rating or "N/A"
    local cfRating = config.codeforces_rating or "N/A"
    local language = config.preferred_language or "N/A"
    local editor = config.preferred_editor or "N/A"

    local buf = vim.api.nvim_create_buf(false, true)

    vim.cmd("rightbelow vsplit")
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)
    vim.api.nvim_win_set_width(win, 60)

    local lines = {
        "╭──────────────────────────────────────────────────────────────╮",
        string.format("│             Welcome, %-36s │", name),
        "│                                                              │",
        string.format("│ AKA %-20s on LeetCode │", leetcode),
        string.format("│ and %-20s on Codeforces │", cf),
        "│                                                              │",
        "│ Ratings:                                                     │",
        string.format("│   LeetCode: %-45s │", leetRating),
        string.format("│   Codeforces: %-43s │", cfRating),
        "│                                                              │",
        string.format("│ Language: %-46s │", language),
        string.format("│ Code Editor: %-43s │", editor),
        string.format("│ High Score: %-45s │", highScore),
        "│                                                              │",
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

    local nsId = vim.api.nvim_create_namespace("cpvimDashboard")

    vim.api.nvim_buf_add_highlight(buf, nsId, "Title", 1, 0, -1)
    vim.api.nvim_buf_add_highlight(buf, nsId, "Keyword", 3, 0, -1)
    vim.api.nvim_buf_add_highlight(buf, nsId, "Keyword", 4, 0, -1)
    vim.api.nvim_buf_add_highlight(buf, nsId, "Keyword", 6, 0, -1)

    vim.api.nvim_buf_add_highlight(buf, nsId, "Comment", 7, 0, -1)
    vim.api.nvim_buf_add_highlight(buf, nsId, "String", 8, 0, -1)
    vim.api.nvim_buf_add_highlight(buf, nsId, "String", 9, 0, -1)

    vim.api.nvim_buf_add_highlight(buf, nsId, "Type", 11, 0, -1)
    vim.api.nvim_buf_add_highlight(buf, nsId, "Type", 12, 0, -1)
    vim.api.nvim_buf_add_highlight(buf, nsId, "Type", 13, 0, -1)

    local opts = { noremap = true, silent = true, buffer = buf }
    vim.keymap.set('n', 'q', '<cmd>close<cr>', opts)

    vim.api.nvim_echo({{"CP Dashboard loaded. Press 'q' to close.", "Normal"}}, false, {})
end

return M