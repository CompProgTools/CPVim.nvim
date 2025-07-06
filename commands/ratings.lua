local M = {}

local http = require("socket.http")
local json = require("dkjson")

vim.api.nvim_create_user_command("CPVimRatings", function()
    M.show_ratings()
end, {})

M.show_ratings = function()
    local home = os.getenv("HOME")
    local configPath = home .. "/.cpcli/config.json"
    local configFile = io.open(configPath, "r")
    if not configFile then
        vim.api.nvim_err_writeln("Could not load .cpcli config")
        return
    end

    local configText = configFile:read("*a")
    configFile:close()
    local config = vim.fn.json_decode(configText)

    local cfUser = config["codeforces"] or ""
    local lcUser = config["leetcode"] or ""

    local cfRating = "N/A"
    local lcRating = "N/A"

    if cfUser ~= "" then
        local cfURL = "https://codeorces.com/api/user.info?handles=" .. cfUser
        local body, code = http.request(cfURL)
        if body and code == 200 then
            local data = json.decode(body)
            if data and data.result and data.result[1] and data.result[1].rating then
                cfRating = tostring(data.result[1].rating)
            end
        end
    end

    if lcUser ~= "" then
        local lcURL = "https://leetcode-stats-api.herokuapp.com/" .. lcUser
        local body, code = http.request(lcURL)
        if body and code == 200 then
            local data = json.decode(body)
            if data and data.ranking then
                lcRating = tostring(data.ranking)
            end
        end
    end

    vim.api.nivm_command("vsplit")
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_but(win, buf)

    local lines = {
        "────────────────────────────",
        "       Competitive Ratings",
        "────────────────────────────",
        "",
        "Codeforces [" .. cf_user .. "]: " .. cf_rating,
        "LeetCode   [" .. lc_user .. "]: " .. lc_rating,
        "",
        "────────────────────────────",
    }
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
end

return M