local config = require("vim-qbuild.config")
local utils = require("vim-qbuild.utils")
local run = require("vim-qbuild.runutils")

local M = {}

-- executes a script with the given run type, from the given directory
local function runFile(options, file)
    local root = utils.getRoot()

    local result

    -- handle run_type option
    if options.runType == config.COMMAND then
        result = run.runInCommand(root, file)
    elseif options.runType == config.TERMINAL then
        run.findTerminal()
        run.runInTerminal(root, file)
    elseif options.runType == config.NEWTERM then
        run.newTerminal()
        run.runInTerminal(root, file)
    end

    return result
end

-- returns 0 on success, 1 on error
-- query: either {}, {index = [int]}, {name = [string]}
-- name has priority
function M.runBuildFile(query)
    local root = utils.getRoot();
    local scriptsDir = utils.getScriptsDir(root)

    local options = config.projectWise(utils.getProjectModule(root))

    local targetName = nil
    local targetIndex = nil

    if (query ~= nil) then
        targetName = query.name
        if targetName == nil then
            targetIndex = query.index
        end
    end

    -- if no query provided, find the default script
    if targetName == nil and targetIndex == nil then
        if options.defaultScript == nil then
            -- if none, just find the first file
            targetIndex = 1
        else
            targetName = options.defaultScript
        end
    end

    local i = 1;

    -- find targeted file and run it
    for name, type in vim.fs.dir(scriptsDir) do
        if type == "file" then
            local path = vim.fs.joinpath(scriptsDir, name)

            if name == targetName or i == targetIndex then
                local result = runFile(options, path)

                if result ~= nil then print(result) end
                return 0
            end

            i = i+1;
        end
    end

    if options.verbose then
        local comment
        if query == nil then
            comment = " "
        elseif query.name ~= nil then
            comment = '"' .. query.name .. '" '
        elseif query.index ~= nil then
            comment = tostring(query.index) .. " "
        end
        print("Target QBuild script " .. comment .. "could not be found")
    end

    return 1
end

return M
