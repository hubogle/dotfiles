local opts = require "nvchad.configs.gitsigns"

-- https://github.com/lewis6991/gitsigns.nvim

opts.current_line_blame = true
opts.current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 300,
    ignore_whitespace = false,
    virt_text_priority = 2047, -- https://github.com/lewis6991/gitsigns.nvim/issues/605
    use_focus = true,
}
opts.numhl = true -- Toggle with `:Gitsigns toggle_numhl`
opts.linehl = false -- Toggle with `:Gitsigns toggle_linehl`
opts.current_line_blame_formatter = "     <author>, <author_time:%R> - <summary> • <abbrev_sha>"
opts.on_attach = function(bufnr)
    local gitsigns = require "gitsigns"

    local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map("n", "]c", function()
        if vim.wo.diff then
            vim.cmd.normal { "]c", bang = true }
        else
            gitsigns.nav_hunk "next"
        end
    end)

    map("n", "[c", function()
        if vim.wo.diff then
            vim.cmd.normal { "[c", bang = true }
        else
            gitsigns.nav_hunk "prev"
        end
    end)

    -- Stage, reset, and navigate hunks
    map("n", "<leader>ga", gitsigns.stage_hunk, { desc = "Stage current hunk" })
    map("n", "<leader>gr", gitsigns.reset_hunk, { desc = "Reset current hunk" })
    map("v", "<leader>gs", function()
        gitsigns.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
    end, { desc = "Stage selected hunk" })
    map("v", "<leader>gr", function()
        gitsigns.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
    end, { desc = "Reset selected hunk" })
    map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "Reset entire buffer" })
    map("n", "<leader>gA", gitsigns.stage_buffer, { desc = "Stage entire buffer" })

    -- Undo staging, preview hunks, and blame
    map("n", "<leader>gu", gitsigns.undo_stage_hunk, { desc = "Undo last hunk stage" })
    map("n", "<leader>gp", gitsigns.preview_hunk, { desc = "Preview current hunk" })
    map("n", "<leader>gb", function()
        gitsigns.blame_line { full = true }
    end, { desc = "Blame current line" })

    -- Diff and toggle visibility of deleted lines
    map("n", "<leader>gd", gitsigns.diffthis, { desc = "Diff current file with staged version" })
    map("n", "<leader>gD", function()
        gitsigns.diffthis "~"
    end, { desc = "Diff current file with last commit" })
    map("n", "<leader>gv", gitsigns.toggle_deleted, { desc = "Toggle visibility of deleted lines" })

    -- Text object for selecting hunks
    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select inner hunk" })
end

return opts
