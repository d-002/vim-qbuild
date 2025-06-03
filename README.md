# vim-qbuild

<!-- qbuild.nvim -->

Quickly run build scripts and more anywhere in your projects, with a simple command.

This plugin allows you to run files stored inside a given project.  
The notion of a "project" is derived from [project.nvim](https://github.com/ahmedkhalf/project.nvim), or in case it is not imported, from the current directory.

The build scripts are executed after a `cd` into their parent directory, hence will not be run from where the command was executed.

## Requirements

- Neovim 0.9+ (theoretically, only tested in 0.11.1)
- [ahmedkhalf/project.nvim](https://github.com/ahmedkhalf/project.nvim)

## Installation

### packer

```lua
-- Lua

use {
    "d-002/vim-qbuild",
    requires = {
        "ahmedkhalf/project.nvim",
    },

    -- optional, to specify a config (override defaults)
    config = function()
        require("vim-qbuild.config").setup() {
            log_all = false,
        }
    end
}
```

## Configuration

Here is a list of the available options:

- `build_dir`: Used to specify the build directory inside the current project. If your project is `~/my_project` and this option is set to `.qbuild`, then the scripts will be searched inside `~/my_project/.qbuild`.
- `log_all`: Whether to log information in case the build file could not be found for example. Shoud be a boolean value.
- `default_index`: The index for the default build file among all the files in the given build directory. Should be a positive integer.
- `ask_create_dir`: Whether to ask the user to create the build dir when trying to open a nonexistent one. If set to `false`, the dir will be created.

Below is an example configuration for vim-qbuild:

```lua
local qbuild = require("vim-qbuild")

-- open the build dir in netrw-vexplore
vim.keymap.set("n", "<leader>qo", qbuild.open_build_dir)

-- run the default build script
vim.keymap.set("n", "<leader>qb", qbuild.run_build_file)

-- run the first build script
vim.keymap.set("n", "<leader>q0", function() qbuild.run_nth_build_file(0) end)
-- run the second build script
vim.keymap.set("n", "<leader>q1", function() qbuild.run_nth_build_file(1) end)
-- and so on
vim.keymap.set("n", "<leader>q2", function() qbuild.run_nth_build_file(2) end)
```

## API

This plugin comes with the following functions:

- `run_nth_build_file(index)`: Run the nth (zero-based) build file, sorted by name. `index` shoud be an integer greater than zero.
- `run_build_file()`: Run the default build file.
- `open_build_dir()`: open the build dir in a new netrw window.

QBuild also defines custom user commands:

- `QBuild`: calls `run_build_file`
- `QBuildDir`: calls `open_build_dir`
