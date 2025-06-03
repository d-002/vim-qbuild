local M = {
    COMMAND = "command",
    TERMINAL = "terminal",
    NEWTERM = "newterm"
}

M.options = {
    build_dir = ".qbuild_scripts",
    log_all = true,
    default_index = 1,
    ask_create_dir = true,
    run_type = M.COMMAND,
}

function M.setup(user_options)
    M.options = vim.tbl_deep_extend("force", M.options, user_options or {})

    if M.options.run_type ~= M.COMMAND and
       M.options.run_type ~= M.TERMINAL and
       M.options.run_type ~= M.NEWTERM then
        error("Incorrect QBuild run_type option, might lead to unintended behavior")
    end
end

return M
