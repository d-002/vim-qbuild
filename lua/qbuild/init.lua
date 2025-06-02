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
    local parent = M.get_scripts_dir();

    print("ok")

    for name, type in vim.fs.dir(parent) do
        if type == "file" then
            local path = vim.fs.joinpath(parent, name)

            if i == index then
                print(vim.fn.system(path))
                return 0
            end

            i = i+1;
        end
    end

    print("Target build file could not be found")

    return 1
end

function M.run_build_file()
    return M.run_nth_build_file(0)
end

vim.keymap.set("n", "<leader>t", function() print(M.get_root()) end)
vim.keymap.set("n", "<leader>b", M.run_build_file)

return M
