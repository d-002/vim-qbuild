-- core features, directly related to building
local run = require("vim-qbuild.run")
-- extra features
local extra = require("vim-qbuild.extra")

local M = {}

M.runBuildFile = run.runBuildFile
M.runNthBuildFile = run.runNthBuildFile
M.openBuildDir = extra.openBuildDir

vim.api.nvim_create_user_command('QBuild', M.runBuildFile, {})
vim.api.nvim_create_user_command('QBuildDir', M.openBuildDir, {})

return M
