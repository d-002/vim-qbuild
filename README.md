# vim-qbuild

<!-- qbuild.nvim -->

Quickly run build scripts and more anywhere in your projects, with a simple command.

This plugin allows you to run files stored inside a given project.  
The notion of a "project" is derived from [project.nvim](https://github.com/ahmedkhalf/project.nvim).
In case this plugin is not imported, the project root is defined as the working directory.

The build scripts are executed after a `cd` into the project root, hence will not be run from where in Neovim the command was executed.

## Requirements

- Neovim 0.9+ (I think, only tested in 0.11.1)
- [ahmedkhalf/project.nvim](https://github.com/ahmedkhalf/project.nvim)

## Installation

### packer

```lua
use {
    "d-002/vim-qbuild",
    requires = "ahmedkhalf/project.nvim",
}
```

## Configuration

Here is a list of the available options:

- `build_dir`: Used to specify the build directory inside the current project.
If your project is `~/my_project` and this option is set to `.qbuild`, then the scripts will be searched inside `~/my_project/.qbuild`.
- `log_all`: Whether to log extra information.
Should be a boolean value.
- `default_index`: The index for the default build file inside the build directory.
Should be a positive integer.
- `ask_create_dir`: Whether to ask the user to create the build dir when trying to open it if it does not exist.
If set to `false`, the dir will be created silently.
- `run_type`: This option defines the behavior when running a build file.
Here are its possible values, any other will result in an error:
    - `COMMAND`: Display the script's output in the command line.
    - `TERMINAL`: Run the script in an existing terminal window (find the first one), or behave like `NEWTERM` if it cannot find one.
    - `NEWTERM`: Create a new terminal window with vsplit, then run the script there.

Below is an example configuration for vim-qbuild:

```lua
local qbuild = require("vim-qbuild")
local qconfig = require("vim-qbuild.config")

-- add custom options if needed (override defaults)
qconfig.setup {
    run_type = qconfig.TERMINAL
}

-- open the build dir in netrw-vexplore
vim.keymap.set("n", "<leader>qo", qbuild.open_build_dir)

-- run the default build script
vim.keymap.set("n", "<leader>qb", qbuild.run_build_file)

-- run the first build script
vim.keymap.set("n", "<leader>q1", function() qbuild.run_nth_build_file(1) end)
-- run the second build script
vim.keymap.set("n", "<leader>q2", function() qbuild.run_nth_build_file(2) end)
-- and so on
vim.keymap.set("n", "<leader>q3", function() qbuild.run_nth_build_file(3) end)
```

## API

This plugin comes with the following functions:

- `run_nth_build_file(index)`: Run the nth (one-based) build file, sorted by name.
`index` shoud be an integer greater than zero.
- `run_build_file()`: Run the default build file.
- `open_build_dir()`: open the build dir in a new netrw window.

QBuild also defines custom user commands:

- `QBuild`: calls `run_build_file`
- `QBuildDir`: calls `open_build_dir`
