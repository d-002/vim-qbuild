local M = {
    COMMAND = "command",
    TERMINAL = "terminal",
    NEWTERM = "newterm"
}

-- default options, should not be changed
M.options_base = {
    verbose = true,
    defaultScript = nil,
    askCreateDir = true,
    runType = M.COMMAND,
    disableProjectWise = false,
}

-- options once the user settings are loaded, can be reused as a base for
-- loading project-wise options
M.options = {}

local function setup(base, userOptions)
    local options = vim.tbl_deep_extend("force", base, userOptions or {})

    if options.runType ~= M.COMMAND and
       options.runType ~= M.TERMINAL and
       options.runType ~= M.NEWTERM then
        error("Incorrect QBuild runType option, might lead to unintended behavior")
    end

    return options
end

function M.setup(userOptions)
    M.options = setup(M.options_base, userOptions)
end

-- path: the custom options file to load, doesn't need to exist
-- returns the options altered by this project's custom options file
function M.projectWise(module)
    -- not authorized
    if M.options.disableProjectWise then
        return M.options
    end

    -- no readable file: return the unaltered options
    local path = module .. ".lua"
    if not vim.loop.fs_stat(path) or not vim.fn.filereadable(path) then
        return M.options
    end

    local projectWise = require(module)
    return setup(M.options, projectWise.options)
end

return M
