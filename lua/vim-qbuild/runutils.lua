local M = {}

function M.newTerminal()
    vim.cmd("vsplit")
    vim.cmd("terminal")
    vim.cmd("startinsert")
end

function M.findTerminal()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)

        if vim.api.nvim_buf_get_option(buf, "buftype") == "terminal" then
            vim.api.nvim_set_current_win(win)
            vim.api.nvim_set_current_buf(buf)
            return
        end
    end

    -- no terminal has been found, create one
    M.newTerminal()
end

-- run file in command line
function M.runInCommand(root, filepath)
    local uv = vim.uv or vim.loop
    local orig_cwd = uv.cwd()

    uv.chdir(root)
    local result = vim.fn.system({ filepath })
    uv.chdir(orig_cwd) -- go back to the previous location

    return result
end

-- run file in terminal
function M.runInTerminal(root, filepath)
    local chan = vim.b.terminal_job_id
    vim.fn.chansend(chan, 'cd "' .. root .. '" ; "' .. filepath .. '"\n')
end

return M
