# CPVim

A Neovim plugin for competitive programming that integrates with your `.cpcli` configuration to load templates and display ratings from various platforms.

## Features

- 🚀 **Template Loading**: Quickly load competitive programming templates with `:CPVim <template>`
- 🔧 **Integration**: Works seamlessly with your existing `.cpcli` setup

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
    "compprogtools/CPVim",
    dependencies = {
    },
    config = function()
        -- Plugin loads automatically
    end
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use 'compprogtools/CPVim'
```

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```lua
Plug 'compprogtools/CPVim'
```
