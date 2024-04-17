
local function copyFileFromClipboard(newfilename)
    vim.cmd('!' .. 'xclip -selection clipboard -t image/jpeg -o > ' .. newfilename)
end

local function copyFile(filename, newfilename)
    vim.fn.system({'cp', filename, newfilename})
end

local function generateFilename()
    return os.time() .. ".jpg"
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
    local target_path = require("mdimage").options.target_path

    vim.fn.mkdir(target_path, "p")

    local new_imagename
    local new_imagepath

    if (input.args ~= '') then
        new_imagename = formatFilename(input.args)
        new_imagepath = target_path .. "/" .. new_imagename

        if vim.fn.filereadable(input.args) == 0 then
            error("File not found")
            return
        end

        copyFile(input.args, new_imagepath)
    else
        new_imagename = generateFilename()
        new_imagepath = target_path .. "/" .. new_imagename

        copyFileFromClipboard(new_imagepath)
        if vim.v.shell_error ~= 0 then
            error("Some shell error")
            return
        end

        if vim.fn.filereadable(new_imagepath) == 0 then
            error("File not found in clipboard")
            return
        end
    end

    local md_tag = createLink(new_imagepath, new_imagename)
    pasteUnderCursor(md_tag)
end


vim.api.nvim_create_autocmd({"FileType", "BufEnter"}, {
    pattern = "markdown",
    callback = function()
        vim.api.nvim_create_user_command("PasteImage", CopyImageAndPasteLink, { nargs = '?', complete = 'file' })
    end
})