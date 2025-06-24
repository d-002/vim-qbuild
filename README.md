# vim-qbuild
<!-- qbuild.nvim -->

> [!WARNING]
> This plugin's code was recently refactored, and most of the global functions have been renamed to use [Camel case](https://en.wikipedia.org/wiki/Camel_case).
> Please check your configuration files if you encounter errors.

Quickly run build scripts and more anywhere in your projects, with a simple command.

This plugin allows you to run files stored inside a given project.  
The notion of a "project" is derived from [project.nvim](https://github.com/ahmedkhalf/project.nvim).
In case this plugin is not imported, the project root is defined as the working directory.

The build scripts are executed after a `cd` into the project root, hence will not be run from where in Neovim the command was executed.

## Requirements

- Neovim 0.9+ (but only tested in 0.11.1)
- [ahmedkhalf/project.nvim](https://github.com/ahmedkhalf/project.nvim) (optional, see above)

## Installation

### packer

```lua
use {
    "d-002/vim-qbuild",
    requires = "ahmedkhalf/project.nvim", -- optional - see readme
}
```

## Configuration

Here is a list of the available options:

- `buildDir`: Used to specify the build directory inside the current project.
If your project is `~/my_project` and this option is set to `.qbuild_scripts`, then the scripts will be searched inside `~/my_project/.qbuild_scripts`.
- `verbose`: Whether to log extra information.
Should be a boolean value.
- `defaultIndex`: The index for the default build file inside the build directory.
Should be a positive integer.
- `askCreateDir`: Whether to ask the user to create the build dir when trying to open it if it does not exist.
If set to `false`, the dir will be created silently.
- `runType`: This option defines the behavior when running a build file.
Here are its possible values, any other will result in an error:
    - `COMMAND`: Display the script's output in the command line.
    - `TERMINAL`: Run the script in an existing terminal window (find the first one), or behave like `NEWTERM` if it cannot find one.
    - `NEWTERM`: Create a new terminal window with vsplit, then run the script there.

These options default to:

```lua
{
    buildDir = ".qbuild",
    verbose = true,
    defaultIndex = 1,
    askCreateDir = true,
    runType = M.COMMAND,
}
```

Below is an example configuration for vim-qbuild:

```lua
local qbuild = require("vim-qbuild")
local qconfig = require("vim-qbuild.config")

-- add custom options if needed (override defaults)
qconfig.setup {
    runType = qconfig.TERMINAL
}

-- open the build dir in netrw-vexplore
vim.keymap.set("n", "<leader>qo", qbuild.openBuildDir)

-- run the default build script
vim.keymap.set("n", "<leader>qb", qbuild.runBuildFile)

-- run the first build script
vim.keymap.set("n", "<leader>q1", function() qbuild.runNthBuildFile(1) end)
-- run the second build script
vim.keymap.set("n", "<leader>q2", function() qbuild.runNthBuildFile(2) end)
-- and so on
vim.keymap.set("n", "<leader>q3", function() qbuild.runNthBuildFile(3) end)
```

## API

This plugin comes with the following functions:

- `runNthBuildFile(index)`: Run the nth (one-based) build file, sorted by name.
`index` shoud be an integer greater than zero.
- `runBuildFile()`: Run the default build file.
- `openBuildDir()`: open the build dir in a new netrw window.

QBuild also defines custom user commands:

- `QBuild`: calls `runBuildFile`
- `QBuildDir`: calls `openBuildDir`
