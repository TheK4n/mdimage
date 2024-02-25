
function ExecCurl(input)
    local cnf = require("mdimage").options

    local note_prefix = cnf.img_path

    local new_imagename =  os.time() .. "_" .. vim.fs.basename(vim.fs.normalize(input.args))

    local new_imagepath = note_prefix .. "/" .. new_imagename

    new_imagepath = vim.fs.normalize(new_imagepath)

    vim.fn.system({'cp', input.args, new_imagepath})

    local md_tag = "![" .. new_imagename .. "](" .. new_imagepath .. ")"

    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_buf_set_text(0, row - 1, col, row - 1, col, { md_tag })
end


vim.api.nvim_create_autocmd({"FileType", "BufEnter"}, {
    pattern = "markdown",
    callback = function()
        vim.api.nvim_create_user_command("PasteImage", ExecCurl, { nargs = 1, complete = 'file' })
    end
})