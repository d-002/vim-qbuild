local M = {}

M.options = {
    build_dir = ".qbuild_scripts",
    log_all = true,
    default_index = 0,
    ask_create_dir = true,
}

function M.setup(user_options)
    M.options = vim.tbl_deep_extend("force", M.options, user_options or {})
end

return M
