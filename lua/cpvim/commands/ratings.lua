local M = {}
local utils = require('cpvim.utils')

M.get_rating_color = function(rating, platform)
    if platform == "codeforces" then
        if rating >= 2400 then return "DiagnosticError"
        elseif rating >= 2100 then return "DiagnosticWarn"
        elseif rating >= 1900 then return "DiagnosticInfo"
        elseif rating >= 1600 then return "DiagnosticHint"
        elseif rating >= 1400 then return "String"
        else return "Comment"
        end
    elseif platform == "leetcode" then
        if rating >= 2500 then return "DiagnosticError"
        elseif rating >= 2200 then return "DiagnosticWarn"
        elseif rating >= 1900 then return "DiagnosticInfo"
        elseif rating >= 1600 then return "String"
        else return "Comment"
        end
    end
    return "Normal"
end

M.show_ratings = function()
    local home = os.getenv("HOME")
    local config_path = home .. "/.cpcli/config.json"

    local file = io.open(config_path, "r")
    if not file then
        vim.api.nvim_err_writeln("Config file not found: " .. config_path)
        return
    end

    local content = file:read("*a")
    file:close()

    local config = utils.parse_json(content)

    local buf = vim.api.nvim_create_buf(false, true)

    vim.cmd("rightbelow vsplit")
    local win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(win, buf)

    vim.api.nvim_win_set_width(win, 40)

    local lines = {
        "╭─────────────────────────────────────╮",
        "│           🏆 CP RATINGS 🏆          │",
        "├─────────────────────────────────────┤",
        "│                                     │",
        "│  📊 CODEFORCES                      │",
        "│  ┌─────────────────────────────────┐ │",
        string.format("│  │ User: %-21s │ │", config.codeforces or "N/A"),
        string.format("│  │ Rating: %-19s │ │", config.codeforces_rating or "N/A"),
        "│  └─────────────────────────────────┘ │",
        "│                                     │",
        "│  🧠 LEETCODE                        │", 
        "│  ┌─────────────────────────────────┐ │",
        string.format("│  │ User: %-21s │ │", config.leetcode or "N/A"),
        string.format("│  │ Rating: %-19s │ │", config.leetcode_rating or "N/A"),
        "│  └─────────────────────────────────┘ │",
        "│                                     │",
        "│  👤 " .. (config.name or "Unknown User") .. string.rep(" ", math.max(0, 25 - (#(config.name or "Unknown User")))) .. "│",
        "│  🔧 " .. (config.preferred_language or "N/A") .. string.rep(" ", math.max(0, 25 - (#(config.preferred_language or "N/A")))) .. "│",
        "│                                     │",
        "╰─────────────────────────────────────╯"
    }

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    vim.api.nvim_buf_set_option(buf, 'modifiable', false)
    vim.api.nvim_buf_set_option(buf, 'readonly', true)
    vim.api.nvim_buf_set_option(buf, 'buftype', 'nofile')
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'wipe')
    vim.api.nvim_buf_set_option(buf, 'swapfile', false)
    vim.api.nvim_buf_set_name(buf, 'CP Ratings')

    vim.api.nvim_win_set_option(win, 'wrap', false)
    vim.api.nvim_win_set_option(win, 'number', false)
    vim.api.nvim_win_set_option(win, 'relativenumber', false)
    vim.api.nvim_win_set_option(win, 'signcolumn', 'no')
    vim.api.nvim_win_set_option(win, 'foldcolumn', '0')
    vim.api.nvim_win_set_option(win, 'cursorline', false)

    local ns_id = vim.api.nvim_create_namespace("cpvim_ratings")

    vim.api.nvim_buf_add_highlight(buf, ns_id, "Comment", 0, 0, -1)
    vim.api.nvim_buf_add_highlight(buf, ns_id, "Title", 1, 0, -1)
    vim.api.nvim_buf_add_highlight(buf, ns_id, "Comment", 2, 0, -1)

    vim.api.nvim_buf_add_highlight(buf, ns_id, "Keyword", 4, 2, 18)
    vim.api.nvim_buf_add_highlight(buf, ns_id, "Keyword", 10, 2, 14)

    if config.codeforces_rating then
        local cf_color = M.get_rating_color(config.codeforces_rating, "codeforces")
        vim.api.nvim_buf_add_highlight(buf, ns_id, cf_color, 7, 12, 12 + #tostring(config.codeforces_rating))
    end

    if config.leetcode_rating then
        local lc_color = M.get_rating_color(config.leetcode_rating, "leetcode")
        vim.api.nvim_buf_add_highlight(buf, ns_id, lc_color, 13, 12, 12 + #tostring(config.leetcode_rating))
    end

    vim.api.nvim_buf_add_highlight(buf, ns_id, "String", 16, 2, -1)
    vim.api.nvim_buf_add_highlight(buf, ns_id, "Type", 17, 2, -1)

    local opts = { noremap = true, silent = true, buffer = buf }
    vim.keymap.set('n', 'q', '<cmd>close<cr>', opts)
    vim.keymap.set('n', '<Esc>', '<cmd>close<cr>', opts)
    vim.keymap.set('n', 'r', function() M.show_ratings() end, opts)

    vim.api.nvim_echo({{"CP Ratings loaded! Press 'q' to close, 'r' to refresh", "Normal"}}, false, {})
end

return M