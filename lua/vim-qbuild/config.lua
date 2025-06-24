local M = {
    COMMAND = "command",
    TERMINAL = "terminal",
    NEWTERM = "newterm"
}

M.options = {
    buildDir = ".qbuild",
    verbose = true,
    defaultIndex = 1,
    askCreateDir = true,
    runType = M.COMMAND,
}

function M.setup(userOptions)
    M.options = vim.tbl_deep_extend("force", M.options, userOptions or {})

    if M.options.runType ~= M.COMMAND and
       M.options.runType ~= M.TERMINAL and
       M.options.runType ~= M.NEWTERM then
        error("Incorrect QBuild run_type option, might lead to unintended behavior")
    end
end

return M
