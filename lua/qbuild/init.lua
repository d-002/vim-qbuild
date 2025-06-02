print("Hello world")

local config = require("qbuild.config")
local M = {}

function get_root()
    local ok, project = pcall(require, "project_nvim.project")
    if not ok then return vim.fn.getcwd() end

    local config_ok, config = pcall(require, "project_nvim.config")
    if config_ok and not config.config then
        require("project_nvim").setup()
    end

    return project.get_project_root() or vim.fn.getcwd()
end

function get_scripts_dir()
    return vim.fs.joinpath(get_root(), config.options.build_dir)
end

function M.run_nth_build_file(index)
    local i = 0;
    local parent = get_scripts_dir();

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

    print("Target qbuild file could not be found")

    return 1
end

function M.open_build_dir()
    local path = get_scripts_dir()
    local stat = vim.uv.fs_stat(path)

    if not stat or stat.type ~= "directory" then
        print("Inexistent or invalid qbuild directory")
        return
    end

    vim.cmd("Vexplore " .. path)
end

function M.run_build_file()
    return M.run_nth_build_file(0)
end

vim.keymap.set("n", "<leader>qb", M.run_build_file)
vim.keymap.set("n", "<leader>q0", function() M.run_build_file(0) end)
vim.keymap.set("n", "<leader>q1", function() M.run_build_file(1) end)
vim.keymap.set("n", "<leader>q2", function() M.run_build_file(2) end)
vim.keymap.set("n", "<leader>qo", M.open_build_dir)

return M
