local config = require("vim-qbuild.config")
local utils = require("vim-qbuild.utils")
local run = require("vim-qbuild.runutils")

local M = {}

-- executes a script with the given run type, from the given directory
local function runFile(file)
    local root = utils.getRoot()
    local filepath = vim.fs.joinpath(
        config.options.buildDir,
        vim.fs.basename(file)
    )

    local result

    -- handle run_type option
    if config.options.runType == config.COMMAND then
        run.runInCommand(root, filepath)
    elseif config.options.runType == config.TERMINAL then
        run.findTerminal()
        run.runInTerminal(root, filepath)
    elseif config.options.runType == config.NEWTERM then
        run.newTerminal()
        run.runInTerminal(root, filepath)
    end

    return result
end

-- returns 0 on success, 1 on error
function M.runNthBuildFile(index)
    local i = 1;
    local root = utils.getScriptsDir();

    -- find nth file inside the scripts dir and run it
    for name, type in vim.fs.dir(root) do
        if type == "file" then
            local path = vim.fs.joinpath(root, name)

            if i == index then
                local result = runFile(path)

                if result ~= nil then print(result) end
                return 0
            end

            i = i+1;
        end
    end

    if config.options.verbose then
        print("Target QBuild script could not be found")
    end

    return 1
end

-- returns 0 on success, 1 on error
function M.runBuildFile()
    return M.runNthBuildFile(config.options.defaultIndex)
end

return M
