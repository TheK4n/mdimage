<div align="center">

# mdimage.nvim

[Install](#install) • [Usage](#usage)

</div>

---

Neovim plugin for copy image and paste to markdown


## Install

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
return {
    "thek4n/mdimage.nvim",
    config = function()
        require("mdimage").setup({
            target_path = vim.env.HOME .. "/.notes/.img",
        })
    end
}
```

### Default configuration

By default plugin will copy image to current work directory

```lua
local default_config = {
    target_path = "./.img"
}
```

## Usage

Command: \
`:PasteImage ~/path/to/image` \
will copy specified image to target directory and paste link to image

Command: \
`:PasteImage` \
will copy image from clipboard to target directory and paste link to image