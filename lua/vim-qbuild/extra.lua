local config = require("vim-qbuild.config")
local utils = require("vim-qbuild.utils")

local M = {}

local function create_dir(path) vim.fn.mkdir(path, "p") end
local function open_dir(path) vim.cmd("Vexplore " .. path) end

function M.openBuildDir()
    local path = utils.getScriptsDir()
    local uv = vim.uv or vim.loop
    local stat = uv.fs_stat(path)

    -- no dir: ask or create it
    if not stat then
        if config.options.askCreateDir then
            vim.ui.input(
                { prompt = "Create missing dir " .. path .. "? [Y/n] " },

                function(input)
                    if utils.isYes(input) then
                        create_dir(path)
                        open_dir(path)
                    elseif config.options.verbose then
                        print("Operation cancelled by user")
                    end
                end
            )

        else
            create_dir(path)
            open_dir(path)
        end

    -- not a dir: abort
    elseif stat.type ~= "directory" then
        if config.options.verbose then
            print(path .. " is not a directory")
        end

    -- ok
    else
        open_dir(path)
    end
end

return M
