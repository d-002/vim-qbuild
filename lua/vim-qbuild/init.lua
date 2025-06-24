local config = require("vim-qbuild.config")
local run = require("vim-qbuild.run")
local extra = require("vim-qbuild.extra")

local M = {}

function M.setup(userOptions)
    config.setup(userOptions)
end

M.runBuildFile = run.runBuildFile
M.runNthBuildFile = run.runNthBuildFile
M.openBuildDir = extra.openBuildDir

vim.api.nvim_create_user_command('QBuild', M.runBuildFile, {})
vim.api.nvim_create_user_command('QBuildDir', M.openBuildDir, {})

return M
