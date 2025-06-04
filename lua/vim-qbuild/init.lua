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

-- executes a script with the given run type, from the given directory
function run_build_file(dir, file)
    local uv = vim.uv or vim.loop
    local orig_cwd = uv.cwd()

    local result

    function find_terminal()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = vim.api.nvim_win_get_buf(win)

            if vim.api.nvim_buf_get_option(buf, "buftype") == "terminal" then
                local chan_id = vim.b[buf].terminal_job_id
                vim.api.nvim_set_current_win(win)
                vim.api.nvim_set_current_buf(buf)
                return
            end
        end

        -- no terminal has been found, create one
        new_terminal()
    end

    function new_terminal()
        vim.cmd("vsplit")
        vim.cmd("terminal")
        vim.cmd("startinsert")
    end

    function run_in_command()
        uv.chdir(dir)
        result = vim.fn.system({ file })
        uv.chdir(orig_cwd)
    end

    function run_in_terminal()
        local chan = vim.b.terminal_job_id
        vim.fn.chansend(chan, "cd " .. dir .. "\n./" .. vim.fs.basename(file) .. "\n")
    end

    -- handle run_type option
    if config.options.run_type == config.COMMAND then
        run_in_command()
    elseif config.options.run_type == config.TERMINAL then
        find_terminal()
        run_in_terminal()
    else
        new_terminal()
        run_in_terminal()
    end

    return result
end

-- returns 0 on success, 1 on error
function M.run_nth_build_file(index)
    local i = 1;
    local root = get_scripts_dir();

    -- find nth file inside the scripts dir and run it
    for name, type in vim.fs.dir(root) do
        if type == "file" then
            local path = vim.fs.joinpath(root, name)

            if i == index then
                local result = run_build_file(root, path)

                if result ~= nil then print(result) end
                return 0
            end

            i = i+1;
        end
    end

    if config.options.log_all then
        print("Target QBuild script could not be found")
    end

    return 1
end

function M.run_build_file()
    return M.run_nth_build_file(config.options.default_index)
end

function is_yes(str)
    return
        str ~= nil
        and string.len(str) > 0
        and string.lower(string.sub(str, 1, 1)) == "y"
end

function M.open_build_dir()
    local path = get_scripts_dir()
    local stat = vim.uv.fs_stat(path)

    function create_dir()
        vim.fn.mkdir(path, "p")
    end

    function open_dir()
        vim.cmd("Vexplore " .. path)
    end

    -- no dir: ask or create it
    if not stat then
        if config.options.ask_create_dir then
            vim.ui.input(
                { prompt = "Create missing dir " .. path .. "? [Y/n] " },

                function(input)
                    if is_yes(input) then
                        create_dir()
                        open_dir()
                    elseif config.options.log_all then
                        print("Operation cancelled by user")
                    end
                end
            )

        else
            create_dir()
            open_dir()
        end

    -- not a dir: abort
    elseif stat.type ~= "directory" then
        if config.options.log_all then
            print(path .. " is not a directory")
        end

    -- ok
    else
        open_dir()
    end
end

vim.api.nvim_create_user_command('QBuild', M.run_build_file, {})
vim.api.nvim_create_user_command('QBuildDir', M.open_build_dir, {})

return M
