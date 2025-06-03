local config = require("vim-qbuild.config")
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

-- executes a script as if it were run in the directory it is stored
function run_in_dir(file)
    local uv = vim.uv or vim.loop
    local dir = vim.fs.dirname(file)
    local orig_cwd = uv.cwd()

    uv.chdir(dir)
    local result = vim.fn.system({ file })
    uv.chdir(orig_cwd)

    return result
end

function M.run_nth_build_file(index)
    local i = 0;
    local parent = get_scripts_dir();

    for name, type in vim.fs.dir(parent) do
        if type == "file" then
            local path = vim.fs.joinpath(parent, name)

            if i == index then
                local result = run_in_dir(path)

                if config.options.log_all then print(result) end
                return 0
            end

            i = i+1;
        end
    end

    if config.options.log_all then
        print("Target QBuild file could not be found")
    end

    return 1
end

function M.run_build_file()
    return M.run_nth_build_file(config.options.default_index)
end

function is_yes(str)
    return str ~= nil and string.len(str) > 0 and string.lower(string.sub(str, 1, 1)) == "y"
end

function M.open_build_dir()
    local path = get_scripts_dir()
    local stat = vim.uv.fs_stat(path)

    if not stat then
        if config.options.ask_create_dir then
            vim.ui.input(
                { prompt = "Create missing dir " .. path .. "? [Y/n] " },

                function(input)
                    if is_yes(input) then
                        vim.fn.mkdir(path, "p")
                        vim.cmd("Vexplore " .. path)
                    elseif config.options.log_all then
                        print("Operation cancelled by user")
                    end
                end
            )

            return -- the rest of the actions is handled asynchronously
        else
        end
    elseif stat.type ~= "directoryy" then
        if config.options.log_all then
            print(path .. " is not a directory")
        end

        return
    end

    vim.cmd("Vexplore " .. path)
end

vim.api.nvim_create_user_command('QBuild', M.run_build_file, {})
vim.api.nvim_create_user_command('QBuildDir', M.open_build_dir, {})

return M
