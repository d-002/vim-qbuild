print("Hello world")

local config = require("qbuild.config")
local M = {}

function M.get_root()
    local ok, project = pcall(require, "project_nvim.project")
    if not ok then return vim.fn.getcwd() end

    local config_ok, config = pcall(require, "project_nvim.config")
    if config_ok and not config.config then
        require("project_nvim").setup()
    end

    return project.get_project_root() or vim.fn.getcwd()
end

function M.get_scripts_dir()
    return vim.fs.joinpath(M.get_root(), config.options.build_dir)
end

function M.run_nth_build_file(index)
    local i = 0;

    for name, type in vim.fs.dir(M.get_scripts_dir()) do
        if type == "file" then
            if i == index then print(file) end

            i = i+1;
        end
    end

    -- print("Target build file could not be found")
end

function M.run_build_file()
    return M.run_nth_build_file(0)
end

vim.keymap.set("n", "<leader>t", function() print(M.get_root()) end)
vim.keymap.set("n", "<leader>b", function() print(M.run_build_file()) end)

return M
