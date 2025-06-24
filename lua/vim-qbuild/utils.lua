local M = {}

function M.getRoot()
    local ok, project = pcall(require, "project_nvim.project")
    if not ok then return vim.fn.getcwd() end

    local config_ok, p_config = pcall(require, "project_nvim.config")
    if config_ok and not p_config.config then
        require("project_nvim").setup()
    end

    return project.get_project_root() or vim.fn.getcwd()
end

function M.getScriptsDir(config)
    return vim.fs.joinpath(M.getRoot(), config.options.buildDir)
end

function M.isYes(str)
    return
        str ~= nil
        and string.len(str) > 0
        and string.lower(string.sub(str, 1, 1)) == "y"
end

return M
