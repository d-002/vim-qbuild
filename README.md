# vim-qbuild
<!-- qbuild.nvim -->

Quickly run build scripts and more anywhere in your projects, with a simple command.

This plugin allows you to run files stored inside a given project.
The notion of a "project" is derived from [project.nvim](https://github.com/ahmedkhalf/project.nvim).
In case this plugin is not imported, the project root is defined as the working directory.

The build scripts are executed after a `cd` into the project root, hence will not be run from where in Neovim the command was executed, so feel free to wander around in your project and rely on simple remaps to launch files.

Scripts are searched in the `[project root]/.qbuild/scripts` directory.
The `[project root]/.qbuild` directory is also where the project-wise config file should be placed, if needed (see below).

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

- `verbose`: Whether to log extra information.
Should be a boolean value.
- `defaultScript`: The default script name to run.
Should be a string, or `nil` to revert to finding the first file in the scripts directory.
- `askCreateDir`: Whether to ask the user to create the build dir when trying to open it if it does not exist.
Should be a boolean value.
If set to `false`, the dir will be created silently.
- `runType`: This option defines the behavior when running a build file.
Here are its possible values, any other will result in an error (`qconfig` refers to the `vim-qbuild.config` file):
    - `qconfig.COMMAND`: Display the script's output in the command line.
    - `qconfig.TERMINAL`: Run the script in an existing terminal window (find the first one), or behave like `NEWTERM` if it cannot find one.
    - `qconfig.NEWTERM`: Create a new terminal window with vsplit, then run the script there.
- `disableProjectWise`: disable loading project-wise options files (for security purposes, see subsection below).
Should be a boolean value.

These options default to:

```lua
{
    verbose = true,
    defaultScript = nil,
    askCreateDir = true,
    runType = M.COMMAND,
    disableProjectWise = false,
}
```

### Example configuration

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

-- run the build script named "main"
vim.keymap.set("n", "<leader>qm", function() qbuild.runBuildFile({name="main"}) end)

-- run the first build script
vim.keymap.set("n", "<leader>q1", function() qbuild.runBuildFile({index=1}) end)
-- run the second build script
vim.keymap.set("n", "<leader>q2", function() qbuild.runBuildFile({index=2}) end)
-- and so on
vim.keymap.set("n", "<leader>q3", function() qbuild.runBuildFile({index=3}) end)
```

### Project-wise options

On top of being able to set global, custom options through vim-qbuild's `M.setup` function, it is possible to specify project-wise options by creating `[project root]/.qbuild/config.lua`.

This file should contain specific lua-like code, that will be used to alter the configuration.
It should define `M.options`, a dictionary with all the project-wise values.

Be careful about the code you put in there, as the module will be executed on your machine!
If you want to avoid security issues with shared configurations for example, feel free to turn on the `disableProjectWise` global option.

An example projet-wise options file could look like this:

```lua
-- if needed, to access runType constants for example
local qconfig = require("vim-qbuild.config")

-- MUST follow this syntax and define global config
config = {
    -- default build script
    defaultScript = "main",
    -- don't use a terminal for this project
    runType = qconfig.COMMAND,
}
```

## API

This plugin comes with the following functions:

- `runBuildFile(query)`: Run a build file.
The optional `query` parameter can be either:
    - `nil`: find and run the first build file in the scripts directory
    - `{index = n}`: find and run the nth (`n` should be an integer greater than 0) file in the script directory.
    Scripts are ordered by name.
    - `{name = "name"}`: find and run the script named `[project root]/.qbuild/scripts/name`.
    In case both the name and index are specified, the name will be the one target.
- `openBuildDir()`: open the build dir in a new netrw window.

QBuild also defines custom user commands:

- `QBuild`: calls `runBuildFile`
- `QBuildDir`: calls `openBuildDir`
