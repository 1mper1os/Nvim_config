local status_ok, ufo = pcall(require, "ufo")
if not status_ok then
    return
end

ufo.setup({
    provider_selector = function(bufnr, filetype, buftype)
        return { "treesitter", "indent" }
    end,

    fold_virt_text_handler = nil,
    open_fold_hl_timeout = 400,

    -- Opción corregida: close_fold_kinds → close_fold_kinds_for_ft
    close_fold_kinds_for_ft = {
        ["*"] = { "imports", "comment" }  -- Aplica a todos los archivos
    },

    preview = {
        win_config = {
            border = "rounded",
            winhighlight = "Normal:Folded",
        },
        mappings = {
            scrollU = "<C-u>",
            scrollD = "<C-d>",
        },
    },

    keymaps = {
        open_all_folds = "zR",
        close_all_folds = "zM",

        open_fold = "zo",
        close_fold = "zc",
        open_fold_recursively = "zO",
        close_fold_recursively = "zC",

        preview_fold = "zp",
    },
})
