local config = require("vim-qbuild.config")
local utils = require("vim-qbuild.utils")

local M = {}

local function create_dir(path) vim.fn.mkdir(path, "p") end
local function open_dir(path) vim.cmd("Vexplore " .. path) end

function M.openBuildDir()
    local root = utils.getRoot();
    local scriptsDir = utils.getScriptsDir(root)
    local options = config.projectWise(utils.getProjectModule(root))

    local uv = vim.uv or vim.loop
    local stat = uv.fs_stat(scriptsDir)

    -- no dir: ask or create it
    if not stat then
        if options.askCreateDir then
            vim.ui.input(
                { prompt = "Create missing dir " .. scriptsDir .. "? [Y/n] " },

                function(input)
                    if utils.isYes(input) then
                        create_dir(scriptsDir)
                        open_dir(scriptsDir)
                    elseif options.verbose then
                        print("Operation cancelled by user")
                    end
                end
            )

        else
            create_dir(scriptsDir)
            open_dir(scriptsDir)
        end

    -- not a dir: abort
    elseif stat.type ~= "directory" then
        if options.verbose then
            print(scriptsDir .. " is not a directory")
        end

    -- ok
    else
        open_dir(scriptsDir)
    end
end

return M
