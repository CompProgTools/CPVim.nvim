# Welcome to CPVim Documentation

This is the official site for the CPVim.nvim plugin made by [CompProgTools](https://github.com/compprogtools).

# Table of Contents
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Installation](#installation)

## Introduction

CPVim is a Neovim plugin that aims to improve worflow and productivity for neovim users that are interested in competitive programming.

It targets template usage, stats, and other info that is known to be useful for contest environments, as well as general learning.

## Prerequisites

Since CPVim.nvim is a part of the [CompProgTools](https://github.com/compprogtools) ecosystem, it requires the usage of [CPCli](https://github.com/compprogtools/cpcli) our command line tool that provides deeper functionality than CPVim. Since CPVim uses the same config files and other data files such as streaks and problems, CPCli is a prerequisite that needs to be installed in order for CPVim to work.

## Installation

Once you have CPCli installed and setup, you can check your `~/.cpcli` path. If it exists, and it has the files `config.json` and `streak.json`, you are good to go!

If you're using a Plugin manager such as Lazy.nvim or Packer, here are the steps.

### Lazy.nvim

```lua
{
  "compprogtools/CPVim.nvim",
  lazy = false, -- ensure it loads on startup
  config = function()
  end,
  cmd = { "CPVim"}, -- ensure the plugin loads when these commands are used
}
```

Or if you're using a structured setup,

```lua
return {
  "compprogtools/CPVim.nvim",
  lazy = false, -- ensure it loads on startup
  config = function()
  end,
  cmd = { "CPVim"}, -- ensure the plugin loads when these commands are used
}
```

### Packer

`use 'compprogtools/CPVim'`

### vim-plug

`Plug 'compprogtools/CPVim'`


Once thats done, you go into Neovim by running `nvim` and type in `:CPVim`.

If running this command doesn't return `Not an editor command: CPVim`, that means you're good to go!