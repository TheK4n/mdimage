
local function copyFile(filename, newfilename)
    vim.fn.system({'cp', filename, newfilename})
end

local function formatFilename(filename)
    return os.time() .. "_" .. vim.fs.basename(vim.fs.normalize(filename))
end

local function createLink(path, name)
    local new_imagepath = vim.fs.normalize(path)
    return "![" .. name .. "](" .. new_imagepath .. ")"
end

local function pasteUnderCursor(text)
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { text })
end

function CopyImageAndPasteLink(input)
    local note_prefix = require("mdimage").options.target_path

    local new_imagename = formatFilename(input.args)
    local new_imagepath = note_prefix .. "/" .. new_imagename

    copyFile(input.args, new_imagepath)

    local md_tag = createLink(new_imagepath, new_imagename)
    pasteUnderCursor(md_tag)
end


vim.api.nvim_create_autocmd({"FileType", "BufEnter"}, {
    pattern = "markdown",
    callback = function()
        vim.api.nvim_create_user_command("PasteImage", CopyImageAndPasteLink, { nargs = 1, complete = 'file' })
    end
})